require 'rename_mp3s'

class FakeTag
  attr_accessor :title, :track, :album, :artist

  def initialize(options)
    @title = options[:title]
    @track = options[:track]
    @album = options[:album]
    @artist = options[:artist]
  end
end

describe Mp3Renamer do
  before(:each) do
    @tag = FakeTag.new(:title => 'Title', :track => '1', :album => 'Album', :artist => 'Artist')
    ID3Lib::Tag.stub!(:new).and_return(@tag)
    @renamer = Mp3Renamer.new(nil)
  end

  describe 'should rename correctly' do
    it 'with only track title' do
      @tag.track = ''
      @tag.album = ''
      @tag.artist = ''
      @renamer.rename.should == 'Title'
    end

    it 'with only track number and artist' do
      @tag.album = ''
      @tag.title = ''
      @renamer.rename.should == '1 - Artist'
    end

    it 'with only track number and album' do
      @tag.artist = ''
      @tag.title = ''
      @renamer.rename.should == '1 - Album'
    end

    it 'with only track number, artist and title' do
      @tag.album = ''
      @renamer.rename.should == '1 - Artist - Title'
    end

    it 'with only artist and title' do
      @tag.album = ''
      @tag.track = ''
      @renamer.rename.should == 'Artist - Title'
    end

    it 'with only track number and title' do
      @tag.artist = ''
      @tag.album = ''
      @renamer.rename.should == '1 - Title'
    end

    it 'with nils' do
      @tag.artist = nil
      @tag.album = nil
      @renamer.rename.should == '1 - Title'
    end

    it 'with track number, artist, album and title' do
      @renamer.rename.should == '1 - Artist - Album - Title'
    end
  end

  it 'should raise error without track number or title' do
    @tag.track = ''
    @tag.title = ''
    lambda { @renamer.rename }.should raise_error(RuntimeError)
  end
end

