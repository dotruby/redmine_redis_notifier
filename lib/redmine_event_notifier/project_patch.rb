module RedmineEventNotifier
  module ProjectPatch
    def archive
      EventNotification.track("archive", self)
      super()
    end

    def unarchive
      EventNotification.track("unarchive", self)
      super()
    end
  end
end

Project.send(:prepend, RedmineEventNotifier::ProjectPatch)
