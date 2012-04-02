if vm = require? 'vm'

  test "Caffeine.eval runs in the global context by default", ->
    global.punctuation = '!'
    code = '''
    global.fhqwhgads = "global superpower#{global.punctuation}"
    '''
    result = Caffeine.eval code
    eq result, 'global superpower!'
    eq fhqwhgads, 'global superpower!'

  test "Caffeine.eval can run in, and modify, a Script context sandbox", ->
    sandbox = vm.Script.createContext()
    sandbox.foo = 'bar'
    code = '''
    global.foo = 'not bar!'
    '''
    result = Caffeine.eval code, {sandbox}
    eq result, 'not bar!'
    eq sandbox.foo, 'not bar!'

  test "Caffeine.eval can run in, but cannot modify, an ordinary object sandbox", ->
    sandbox = {foo: 'bar'}
    code = '''
    global.foo = 'not bar!'
    '''
    result = Caffeine.eval code, {sandbox}
    eq result, 'not bar!'
    eq sandbox.foo, 'bar'
