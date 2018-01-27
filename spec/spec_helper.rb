require 'fakeredis'
Object.instance_eval{ remove_const :Redis }
include FakeRedis
