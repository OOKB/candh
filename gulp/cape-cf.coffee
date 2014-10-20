pkgcloud = require 'pkgcloud'
_ = require 'lodash'

rs_creds = require './rackspace.json'

dev_mode = 'kc' == process.env.USER

cf = pkgcloud.storage.createClient rs_creds

module.exports =
  container_info: (container, marker, callback) ->
    cf.getContainer container, (err, container) =>
      if err or not container
        callback err, container
        return false
      containerInfo =
        count: container.count
        bytes: container.bytes
        metadata: container.metadata
      if container.cdnEnabled
        containerInfo.ttl = container.ttl
        containerInfo.cdn = container.cdnEnabled
        containerInfo.cdnUri = container.cdnUri
        containerInfo.cdnSSLuri = container.cdnSslUri

      options =
        limit: 5000
      if marker
        options.marker = marker

      container.getFiles options, (err, fileList) =>
        if (err)
          callback(err)
          return false

        fileList = @files_map fileList
        result =
          container: containerInfo

        # Put the files into directories.
        where = "contentType": "application/directory"
        result.dirs = _.filter fileList, where
        if true
          result.files = {}
          result.dirs.forEach (dir) ->
            result.files[dir.path] =
              directory: dir
              files:
                _.filter fileList, (model) ->
                  isDir = model.contentType == 'application/directory'
                  model.path.indexOf(dir.path) == 0 and not isDir

        callback null, result

  files_map: (fileList) ->
    fileCount = _.size fileList
    _.map fileList, (value, i) ->
      file_info =
        path: value.name,
        # i: i + 1,
        md5: value.etag,
        contentType: value.contentType,
        lastModified: value.lastModified,
        bytes: value.bytes,
        metadata: value.metadata,
      # if 0 == i
      #   file_info.first = true
      # if fileCount == i + 1
      #   file_info.last = true
      # if 'image' == value.contentType.substring(0,5)
      #   file_info.image = true
      file_info

  delete_file: (req, res) ->
    Make = req.Make
    cf.removeFile Make.make.cdn, req.param(0), (err, result) ->
      if err
        res.json(err.statusCode, err)
      else if result
        res.json({result: result, message: 'deleted'})
      else
        res.json({message: 'i have no idea wtf.'})

  move_file: (req, res) ->
    # Check to see if the body has a source param.
    if body.source
      File = cf.getFile(req.param('container'), req.param(0))

    cf.copy req.param('container'), body.destination, (err, result) ->
      console.log result
      if err
        res.json(err)
      else if result
        res.json({result: result, message: 'moved'})
      else
        return res.json({message: 'i h  ave no idea wtf.'})

  getFiles: (args, callback) ->
    unless args and args.container and callback
      return false
    options =
      limit: args.limit or 10000
    if args.marker
      options.marker = marker
    cf.getFiles args.container, options, (err, fileList) =>
      callback err, null, @files_map(fileList)
