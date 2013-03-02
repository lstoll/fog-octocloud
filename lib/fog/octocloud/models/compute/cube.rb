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

        def save
          requires :name, :source

          data = {}

          attrs = {'name' => identity}#, 'url' => url}
          if remote_id  # we're updating
            data = connection.remote_update_cube(identity, attrs)
          else
            begin
              data = connection.remote_create_cube(attrs)
              md5 = Digest::MD5.file(File.expand_path(source).to_s).hexdigest
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

      end

    end
  end
end
