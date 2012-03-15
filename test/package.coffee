shortcut = package my.package.lib
  class A
  class B
    @A: A

test "test package definition", ->
  ok typeof my.package.lib.A is "function"
  ok typeof A is "undefined"
  ok new my.package.lib.A() instanceof Object
  ok new my.package.lib.A() instanceof my.package.lib.B.A
  ok new my.package.lib.B.A instanceof my.package.lib.A
  ok shortcut is my.package.lib
