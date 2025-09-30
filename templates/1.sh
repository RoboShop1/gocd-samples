curl 'http://3.91.67.76:8153/go/api/admin/templates' \
      -H 'Accept: application/vnd.go.cd.v7+json' \
      -H 'Content-Type: application/json' \
      -X POST -d '{
                   "name": "advanced-echo-template",
                   "stages": [
                     {
                       "name": "build-and-echo",
                       "fetch_materials": true,
                       "clean_working_directory": false,
                       "approval": {
                         "type": "success"
                       },
                       "jobs": [
                         {
                           "name": "build",
                           "tasks": [
                             {
                               "type": "exec",
                               "attributes": {
                                 "command": "echo",
                                 "arguments": ["Starting build process..."],
                                 "run_if": ["passed"]
                               }
                             },
                             {
                               "type": "exec",
                               "attributes": {
                                 "command": "echo",
                                 "arguments": ["Build completed successfully!"],
                                 "run_if": ["passed"]
                               }
                             }
                           ],
                           "resources": ["linux"],
                           "artifacts": [
                             {
                               "source": "target",
                               "destination": "build-output",
                               "type": "build"
                             }
                           ]
                         }
                       ]
                     }
                   ]
                   }'