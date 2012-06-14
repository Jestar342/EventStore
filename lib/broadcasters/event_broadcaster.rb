module EventStore
  class EventBroadcaster
    def broadcast(event)
      listeners.each do | listener |
        listener.listen_to event
      end
    end

    def register_listener(listener)
      listeners << listener
    end

    private
    def listeners
      @listeners ||= []
    end
  end
end