module RedmineEventNotifier
  module ProjectPatch
    def archive
      EventNotification.create(action: "archive", owner: self, current_user_id: User&.current&.id)
      super()
    end

    def unarchive
      EventNotification.create(action: "unarchive", owner: self, current_user_id: User&.current&.id)
      super()
    end
  end
end

Project.send(:prepend, RedmineEventNotifier::ProjectPatch)
