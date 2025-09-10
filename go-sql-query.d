typedef struct {
  uint8_t* ptr;
  size_t len;
} GoString; 

typedef struct {
  uintptr_t size;  
  uintptr_t ptr_bytes;  
  uint32_t hash;
  uint8_t tflag;
  uint8_t align;
  uint8_t field_align;
  uint8_t kind;
} GoRtti;

typedef struct {
  GoRtti* rtti;
  void* ptr;
} GoInterface;

pid$target::database?sql.*.QueryContext:entry {
  this->query = stringof(copyin(arg3, arg4));
  this->args_ptr = arg5;
  this->args_count = arg6;
  printf("%p %d\n", arg5, arg6);

  printf("%s\n", this->query);
  this->iface0 = (GoInterface*) copyin(this->args_ptr, sizeof(GoInterface));
  this->rtti0 = (GoRtti*) copyin((user_addr_t)this->iface0->rtti, sizeof(GoRtti));
  print(*(this->rtti0));

  this->iface1 = (GoInterface*) copyin(this->args_ptr + 1*sizeof(GoInterface), sizeof(GoInterface));
  this->rtti1 = (GoRtti*) copyin((user_addr_t)this->iface1->rtti, sizeof(GoRtti));
  print(*(this->rtti1));

  this->iface2 = (GoInterface*) copyin(this->args_ptr + 2*sizeof(GoInterface), sizeof(GoInterface));
  this->rtti2 = (GoRtti*) copyin((user_addr_t)this->iface2->rtti, sizeof(GoRtti));
  print(*(this->rtti2));

  this->iface3 = (GoInterface*) copyin(this->args_ptr + 3*sizeof(GoInterface), sizeof(GoInterface));
  this->rtti3 = (GoRtti*) copyin((user_addr_t)this->iface3->rtti, sizeof(GoRtti));
  print(*(this->rtti3));
  printf("\n");

  this->go_str1 = (GoString*)copyin((user_addr_t)this->iface1->ptr, sizeof(GoString));
  this->str1 = stringof(copyin((user_addr_t)this->go_str1->ptr, this->go_str1->len));
  printf("str1=%s\n", this->str1);

  this->go_str2 = (GoString*)copyin((user_addr_t)this->iface2->ptr, sizeof(GoString));
  this->str2 = stringof(copyin((user_addr_t)this->go_str2->ptr, this->go_str2->len));
  printf("str2=%s\n", this->str2);

  this->go_str3 = (GoString*)copyin((user_addr_t)this->iface3->ptr, sizeof(GoString));
  this->str3 = stringof(copyin((user_addr_t)this->go_str3->ptr, this->go_str3->len));
  printf("str3=%s\n", this->str3);
}
