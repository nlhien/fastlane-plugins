describe Fastlane::Actions::FossilBuildUtilsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The fossil_build_utils plugin is working!")

      Fastlane::Actions::FossilBuildUtilsAction.run(nil)
    end
  end
end
