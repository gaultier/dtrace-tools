
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
  void* equal_func;
  uint8_t* gc_data;
  int32_t name_offset;
  int32_t ptr_to_this;
} GoType;

typedef struct {
  GoType* rtti;
  void* ptr;
} GoInterface;


typedef struct {
  GoType type;
  GoType* elem;
  GoType* slice;
  uintptr_t len;
} GoArrayType;

pid$target::database?sql.*.QueryContext:entry {
  this->query = stringof(copyin(arg3, arg4)); // Query string.
  printf("%p %d\n", arg5, arg6);

  this->args_ptr = arg5;

  printf("%s\n", this->query);
  this->iface0 = (GoInterface*) copyin(this->args_ptr, sizeof(GoInterface));
  this->rtti0 = (GoType*) copyin((user_addr_t)this->iface0->rtti, sizeof(GoType));
  print(*(this->rtti0));
  printf("\n");

  this->go_arr0 = (GoArrayType*)copyin((user_addr_t)this->iface0->rtti, sizeof(GoArrayType));
  print(*(this->go_arr0));
  this->go_arr0_elem = (GoType*)copyin((user_addr_t)this->go_arr0->elem, sizeof(GoType));
  print(*(this->go_arr0_elem));
  this->go_arr0_slice = (GoType*)copyin((user_addr_t)this->go_arr0->slice, sizeof(GoType));
  print(*(this->go_arr0_slice));

  this->go_str0 = (uint8_t*)copyin((user_addr_t)this->iface0->ptr, 16);
  tracemem(this->go_str0, 16);

  this->iface1 = (GoInterface*) copyin(this->args_ptr + 1*sizeof(GoInterface), sizeof(GoInterface));
  this->rtti1 = (GoType*) copyin((user_addr_t)this->iface1->rtti, sizeof(GoType));
  print(*(this->rtti1));
  printf("\n");

  this->iface2 = (GoInterface*) copyin(this->args_ptr + 2*sizeof(GoInterface), sizeof(GoInterface));
  this->rtti2 = (GoType*) copyin((user_addr_t)this->iface2->rtti, sizeof(GoType));
  print(*(this->rtti2));
  printf("\n");

  this->iface3 = (GoInterface*) copyin(this->args_ptr + 3*sizeof(GoInterface), sizeof(GoInterface));
  this->rtti3 = (GoType*) copyin((user_addr_t)this->iface3->rtti, sizeof(GoType));
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
