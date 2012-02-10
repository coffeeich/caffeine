package my.package.lib
  class A

test "test package definition", ->
  eq my.package.lib.A, A
  ok new my.package.lib.A() instanceof A
  ok new A() instanceof my.package.lib.A
