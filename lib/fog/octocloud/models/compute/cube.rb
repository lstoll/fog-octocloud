require 'fog/core/model'

module Fog
  module Compute
    class Octocloud

      class Cube < Fog::Model

        def self.setup_default_attributes

          identity :name

          attribute :source
          attribute :md5

          # These are the 'octocloud' ones. Get some commonality!
          # identity :id
          # attribute :url
          # attribute :revision
        end
      end

      class LocalCube < Cube
        setup_default_attributes

        def save
          requires :name, :source
          connection.local_import_box(name, source)
        end

        def destroy
          requires :name
          connection.local_delete_box(name)
          true
        end
      end

      class RemoteCube < Cube
        setup_default_attributes

        attribute :remote_id, :aliases => 'id'
        attribute :revision

        def save
          requires :name, :source

          data = {}

          attrs = {'name' => identity}

          # ensure if we already match a remote cube, we fetch the remote_id
          if !remote_id && existcube = connection.cubes.get(name)
            remote_id = existcube.remote_id
            # ensure we have the right md5 while we're at it
            md5 = existcube.md5
          end

          if remote_id  # we're updating
            # check if the source has been specified. If it has, we only only upload if the md5 differs
            # if it hasn't, submit the metadata for revision
            if source && (new_md5 = file_md5(source)) != md5
              connection.remote_upload_cube(remote_id, source)
              data = connection.remote_update_cube(remote_id, attrs.merge({:md5 => new_md5}))
            elsif !source
              data = connection.remote_update_cube(remote_id, attrs)
            else
              # noop
            end
          else
            begin
              data = connection.remote_create_cube(attrs)
              md5 = file_md5(source)
              connection.remote_upload_cube(data['id'], source)
              connection.remote_update_cube(data['id'], {:md5 => md5})
            rescue Exception => e
              p e
              puts exception.backtrace
              connection.remote_delete_cube(data['remote_id'])
              raise e
            end

          end
          merge_attributes(data)
          true

        end

        def destroy
          requires :remote_id
          connection.remote_delete_cube(remote_id)
          true
        end

        # Gets the ID for a named cube, or nil if it doesn't exist.
        private

        def file_md5(path)
          Digest::MD5.file(File.expand_path(path).to_s).hexdigest
        end


      end

    end
  end
end
