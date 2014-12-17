describe GMSEC::Connection do

  context "configured for a local instance of MBServer" do
    before(:each) do
      subject.config[:connectiontype] = :gmsec_mb
    end

    it "should connect and disconnect successfully", integration: true do
      expect(subject.connected?).to be false

      subject.connect
      expect(subject.connected?).to be true

      subject.disconnect
      expect(subject.connected?).to be false
    end

    context "publishing and subscribing a simple message" do
      let(:payload) do
        { foo:     "foo",
          int:     2,
          double:  1.2 }
      end

      before(:each) do
        subject.connect
      end

      after(:each) do
        subject.disconnect
      end

      it "publishes and subscribes to messages", integration: true do
        subject.subscribe("GMSEC.TEST.*")

        subject.publish("GMSEC.TEST.HELLO", payload)

        message = subject.messages.first

        expect(message.subject).to eq("GMSEC.TEST.HELLO")

        # Message and payload should agree.
        payload.keys.each do |key|
          expect(message[key]).to eq(payload[key])
        end
      end

      it "interprets blocks as callbacks to messages", integration: true do
        subject.subscribe("GMSEC.TEST.*") do |connection, message|
          expect(message.subject).to eq("GMSEC.TEST.HELLO")

          # Message and payload should agree.
          payload.keys.each do |key|
            expect(message[key]).to eq(payload[key])
          end

          @pass = true
        end

        subject.publish("GMSEC.TEST.HELLO", payload)

        # Need to dispatch first message
        subject.messages.first

        expect(@pass).to be(true)
      end

      it "enumerates received message via #messages", integration: true do
        subject.subscribe("GMSEC.TEST.*")

        5.times do
          subject.publish("GMSEC.TEST.FOO", payload)
        end

        expect(subject.messages.to_a.length).to be(5)
      end
    end

    context "using autodispatching", integration: true do
      before(:each) do
        subject.connect
      end

      after(:each) do
        subject.stop_auto_dispatch
        subject.disconnect
      end

      it "correctly autodispatches messages as they are received", integration: true do
        @pass = 0

        subject.subscribe("GMSEC.TEST.*") do |connection, message|
          @pass += 1
        end

        subject.subscribe("GMSEC.TEST.FOO") do |connection, message|
          @pass += 1
        end

        subject.start_auto_dispatch

        subject.publish("GMSEC.TEST.FOO", {foo: :bar})

        sleep 1

        expect(@pass).to eq(2)
      end
    end
  end
end
