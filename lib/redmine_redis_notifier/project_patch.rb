module RedmineRedisNotifier
  module ProjectPatch
    def archive
      RedisNotification.track("archive", self)
      super()
    end

    def unarchive
      RedisNotification.track("unarchive", self)
      super()
    end
  end
end

Project.send(:prepend, RedmineRedisNotifier::ProjectPatch)
