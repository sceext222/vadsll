# vadsll.coffee, vadsll/src/
# TODO better command line process

login = require './login'
logout = require './logout'


main = (argv) ->
  # TODO
  # TODO more error process

  if argv[0] == '--login'
    try
      await login()
    catch e
      console.log "ERROR: #{e.stack}"
      throw e
  else if argv[0] == '--logout'
    try
      await logout()
    catch e
      console.log "ERROR: #{e.stack}"
      throw e
  else
    console.log "ERROR: bad command line"
  # TODO

# start from main
main(process.argv[2..])

# TODO
