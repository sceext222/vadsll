# async.coffee, vadsll/src/
# async-Promise wrapper

fs = require 'fs'
child_process = require 'child_process'


read_file = (file_path) ->
  new Promise (resolve, reject) ->
    fs.readFile file_path, 'utf8', (err, data) ->
      if err
        reject err
      else
        resolve data

write_file = (file_path, text) ->
  new Promise (resolve, reject) ->
    fs.writeFile file_path, text, 'utf8', (err) ->
      if err
        reject err
      else
        resolve()

# move file
mv = (from, to) ->
  new Promise (resolve, reject) ->
    fs.rename from, to, (err) ->
      if err
        reject err
      else
        resolve()

# remove file
rm = (file_path) ->
  new Promise (resolve, reject) ->
    fs.unlink file_path, (err) ->
      if err
        reject err
      else
        resolve()

# check if file exist
file_exist = (file_path) ->
  new Promise (resolve, reject) ->
    fs.access file_path, fs.constants.R_OK, (err) ->
      if err
        resolve false
      else
        resolve true

mkdir = (file_path) ->
  new Promise (resolve, reject) ->
    fs.mkdir file_path, (err) ->
      if err
        reject err
      else
        resolve()

fs_open = (file_path, flags) ->
  new Promise (resolve, reject) ->
    fs.open file_path, flags, (err, fd) ->
      if err
        reject err
      else
        resolve fd

fs_write = (fd, text) ->
  new Promise (resolve, reject) ->
    fs.write fd, text, (err) ->
      if err
        reject err
      else
        resolve()

fs_close = (fd) ->
  new Promise (resolve, reject) ->
    fs.close fd, (err) ->
      if err
        reject err
      else
        resolve()


# run shell command, pipe stdin -> stdin, stdout -> stdout, stderr -> stderr, return exit_code
run_cmd = (args) ->
  new Promise (resolve, reject) ->
    cmd = args[0]
    rest = args[1..]
    # DEBUG
    console.log "  run -> #{args.join(' ')}"
    p = child_process.spawn cmd, rest, {
      stdio: 'inherit'
    }
    p.on 'error', (err) ->
      reject err
    p.on 'exit', (exit_code) ->
      resolve exit_code

# run shell command, pipe stdin -> stdin, stderr -> stderr, return stdout as text
call_cmd = (args) ->
  new Promise (resolve, reject) ->
    cmd = args[0]
    rest = args[1..]
    # DEBUG
    console.log "  call -> #{args.join(' ')}"
    p = child_process.spawn cmd, rest, {
      stdio: [process.stdin, 'pipe', process.stderr]
    }
    stdout = []
    p.on 'error', (err) ->
      reject err
    p.on 'exit', (exit_code) ->
      # check exit_code
      if exit_code != 0
        reject exit_code
      else
        resolve Buffer.concat(stdout).toString('utf-8')
    p.stdout.on 'data', (chunk) ->
      stdout.push chunk


module.exports = {
  read_file  # async
  write_file  # async
  mv  # async
  rm  # async
  file_exist  # async
  mkdir  # async
  fs_open  # async
  fs_write  # async
  fs_close  # async

  run_cmd  # async
  call_cmd  # async
}
