# vadsll.coffee, vadsll/src/
# TODO better command line process

login = require './login'
logout = require './logout'


main = (argv) ->
  # TODO

  if argv[0] == '--login'
    await login()
  else if argv[0] == '--logout'
    await logout()
  else
    console.log "ERROR: bad command line"
  # TODO

# start from main
main(process.argv[2..])

# TODO
