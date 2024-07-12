class Scheduler
  def self.q_changed(shows_api, shows_db)
    shows_db.map do |s|
      s_api = shows_api.select{|sa|
        sa[:id] == s[:id]
      }.first

      s if s[:quantity] != s_api[:quantity]
    end.compact
  end
end

class RemoteApi
  def self.get
    [
     { "id": 1, "quantity": 34 },
     { "id": 2, "quantity": 4 },
     { "id": 3, "quantity": 91 },
     { "id": 4, "quantity": 12 },
     { "id": 5, "quantity": 1 }
    ]
  end
end

class Show
  def self.all
    [
     { "id": 1, "quantity": 35, "last_update": 154 },
     { "id": 2, "quantity": 4, "last_update": 10435 },
     { "id": 3, "quantity": 89, "last_update": 7343},
     { "id": 4, "quantity": 15, "last_update": 12704 },
     { "id": 5, "quantity": 2, "last_update": 3865 }
    ]
  end    
end

require "minitest/autorun"

describe Scheduler do
  before do
  end

  describe "should schedule for shows for q was changed and and which have not been updated in the last hour" do
    it "Get show which q had changed" do
      shows_q_changed = [
                         { "id": 1, "quantity": 35, "last_update": 154 },
                         { "id": 3, "quantity": 89, "last_update": 7343},
                         { "id": 4, "quantity": 15, "last_update": 12704 },
                         { "id": 5, "quantity": 2, "last_update": 3865 }
                        ]

      _( Scheduler.q_changed(RemoteApi.get, Show.all) ).must_equal shows_q_changed
    end
  end
end

