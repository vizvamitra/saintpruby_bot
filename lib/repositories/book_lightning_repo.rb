module Repositories
  class BookLightningRepo < ROM::Repository[:lightnings]
    include ArgsImport['rom']

    def all
      lightnings_datetime = lightnings.with(auto_struct: false).keys('*')

      mapper = -> (lightnings_datetime) do
        lightnings_datetime.first.map do |datetime|
          username = lightnings.with(auto_struct: false).get(datetime).one
          { datetime: datetime, username: username }
        end
      end

      mapped = lightnings_datetime >> mapper

      mapped.map_to(Entities::BookedLightning).to_a
    end

    def create(attributes)
      lightnings.map_to(Entities::BookedLightning).command(:create).call(attributes)
    end

    def delete(datetime)
      lightnings.with(auto_map: false, auto_struct: false).del(datetime.iso8601).one
    end

    def by_username(username)
      all.find { |lightning| lightning.username == username }
    end
  end
end
