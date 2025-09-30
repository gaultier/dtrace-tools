package main

import (
	"encoding/csv"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
)

type Event struct {
	Kind     string
	Id       int
	ParentId int
	Ppid     int
	Pid      int
	Tid      int
	Ts       int
	Basename string
	Execname string
	Argc     int
	Argv     string
}

func main() {
	file, err := os.Open(os.Args[1])
	if err != nil {
		panic(err)
	}

	r := csv.NewReader(file)
	r.FieldsPerRecord = 11
	r.LazyQuotes = true
	r.Comma = '\uFFFC'
	r.ReuseRecord = false

	idToEvent := make(map[int]Event)

	fmt.Println("digraph {  concentrate=true\n")

	for i := 0; ; i++ {
		row, err := r.Read()
		if err == io.EOF {
			break
		}

		if err != nil {
			panic(err)
		}
		if i == 0 { // Skip header.
			continue
		}
		if len(row) != 11 {
			fmt.Fprintf(os.Stderr, "skipping record with unexpected number of fields %d: %+v\n", len(row), row)
			continue
		}

		var event Event

		event.Kind = row[0]
		event.Id, err = strconv.Atoi(row[1])
		if err != nil {
			panic(err)
		}
		event.ParentId, err = strconv.Atoi(row[2])
		if err != nil {
			panic(err)
		}
		event.Ppid, err = strconv.Atoi(row[3])
		if err != nil {
			panic(err)
		}

		event.Pid, err = strconv.Atoi(row[4])
		if err != nil {
			panic(err)
		}

		event.Tid, err = strconv.Atoi(row[5])
		if err != nil {
			panic(err)
		}

		event.Ts, err = strconv.Atoi(row[6])
		if err != nil {
			panic(err)
		}

		event.Basename = row[7]
		// execname := row[7]

		event.Argv = row[10]

		if event.Kind == "B" {
			if event.Basename == "go" && len(event.Argv) > 3 {
				fields := strings.Fields(event.Argv)
				event.Basename = fields[0] + " " + fields[1]
			}
			idToEvent[event.Id] = event
		} else if event.Kind == "E" {
			beginEvent, ok := idToEvent[event.Id]
			if !ok {
				fmt.Fprintf(os.Stderr, "missing begin event, skipping: %+v\n", event)
				continue
			}
			elapsed := event.Ts - beginEvent.Ts
			parent, ok := idToEvent[event.ParentId]

			if !ok {
				fmt.Errorf("no parent info: id=%d pid=%d ppid=%d", event.Id, event.Pid, event.Ppid)
			} else {
				if parent.Basename != beginEvent.Basename {
					fmt.Printf("%s -> %s [tooltip=\"%d ms\", label=%s];\n", strconv.Quote(parent.Basename), strconv.Quote(beginEvent.Basename), elapsed/1000_000, strconv.Quote(beginEvent.Argv))
				}
			}
		}
	}
	fmt.Println("}")
}
