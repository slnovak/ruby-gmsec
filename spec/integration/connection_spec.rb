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

        expect(message.length).to eq(3)

        payload.keys.each do |key|
          expect(message[key]).to eq(payload[key])
        end

      end


      it "interprets blocks as callbacks to message" do

        subject.subscribe("GMSEC.TEST.*") do |connection, message|

          message = connection.messages.first

          expect(message.subject).to eq("GMSEC.TEST.HELLO")

          expect(message.length).to eq(3)

          payload.keys.each do |key|
            expect(message[key]).to eq(payload[key])
          end

        end

        subject.publish("GMSEC.TEST.HELLO", payload)

        sleep 1

      end

    end

  end

end
