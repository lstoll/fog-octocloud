require 'fog/core/model'

module Fog
  module Compute
    class Octocloud

      class Cube < Fog::Model

        def self.setup_default_attributes

          identity :name

          attribute :source
          attribute :md5
          attribute :username
          attribute :password

          # These are the 'octocloud' ones. Get some commonality!
          # identity :id
          # attribute :url
          # attribute :revision
        end

        # Gets the ID for a named cube, or nil if it doesn't exist.
        protected

        def file_md5(path)
          path = Pathname.new(path).expand_path
          if path.exist?
            Digest::MD5.file(path.to_s).hexdigest
          end
        end
      end

      class LocalCube < Cube
        setup_default_attributes

        # Create a new local cube from a local/remote source.
        #
        # Requires :name and :source attributes.
        #
        # :source can be either a local or remote (HTTP) box/ova
        #
        # @example
        #     octoc = Fog::Compute.new( :provider => 'octocloud' )
        #     octoc.cubes.create :name => 'test-cube',
        #                        :source => "https://foo.bar/my-remote.ova",
        #                        :extra_opts => { :show_progress => false }
        #
        def save
          requires :name, :source
          source_md5 = file_md5(source)
          if exist_cube = service.cubes.get(name)
            if exist_cube.md5 == source_md5
              # Nothing has changed, bail
              return
            else
              # Kill it, so we can re-import
              exist_cube.destroy
            end
          end
          if File.extname(source) == '.vmdk'
            service.local_import_vmdk(name, source, source_md5, attributes)
          else
            service.local_import_box(name, source, source_md5, attributes[:extra_opts])
          end
        end

        def destroy
          requires :name
          service.local_delete_box(name)
          true
        end
      end

      class RemoteCube < Cube
        setup_default_attributes

        attribute :remote_id, :aliases => 'id'
        attribute :revision
        attribute :md5, :aliases => 'checksum'
        attribute :meta

        def username
          meta['username']
        end

        def password
          meta['password']
        end

        def save
          requires :name, :source

          data = {}

          # ensure if we already match a remote cube, we fetch the remote_id
          if !remote_id && existcube = service.cubes.get(name)
            remote_id = existcube.remote_id
            # ensure we have the right md5 while we're at it
            md5 = existcube.md5
          end


          if self.remote_id  # we're updating
            # check if the source has been specified. If it has, we only only upload if the md5 differs
            # if it hasn't, submit the metadata for revision
            if source && (new_md5 = file_md5(source)) != md5
              service.remote_upload_cube(remote_id, source)
              data = service.remote_update_cube(remote_id, (meta || {}).merge(:checksum => new_md5))
            elsif !source
              data = service.remote_update_cube(remote_id, :meta => meta)
            else
              # noop
            end
          else
            begin
              data = service.remote_create_cube(identity, attributes.reject {|k,_| k == :source })
              md5 = file_md5(source)
              service.remote_upload_cube(data['id'], source)
              service.remote_update_cube(data['id'], (meta || {}).merge(:checksum => md5))
            rescue Exception => e
              # service.remote_delete_cube(data['id'])
              raise e
            end

          end
          merge_attributes(data)
          true

        end

        def destroy
          requires :remote_id
          service.remote_delete_cube(remote_id)
          true
        end


      end

    end
  end
end
