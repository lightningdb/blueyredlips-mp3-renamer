require 'rename_mp3s'

describe Mp3Renamer do
  before(:each) do
    @renamer = Mp3Renamer.new
  end

  def create_tags(options)
    @tag = mock('fake_tag', options)
    ID3Lib::Tag.stub!(:new).and_return(@tag)
  end

  describe 'should rename correctly' do
    it 'with only track title' do
      create_tags(:title => 'Title', :track => '', :album => '', :artist => '')
      @renamer.rename.should == 'Title'
    end

    it 'with only track number and artist' do
      create_tags(:title => '', :track => '1', :album => '', :artist => 'Artist')
      @renamer.rename.should == '1 - Artist'
    end

    it 'with only track number and album' do
      create_tags(:title => '', :track => '1', :album => 'Album', :artist => '')
      @renamer.rename.should == '1 - Album'
    end

    it 'with only track number, artist and title' do
      create_tags(:title => 'Title', :track => '1', :album => '', :artist => 'Artist')
      @renamer.rename.should == '1 - Artist - Title'
    end

    it 'with only artist and title' do
      create_tags(:title => 'Title', :track => '', :album => '', :artist => 'Artist')
      @renamer.rename.should == 'Artist - Title'
    end

    it 'with only track number and title' do
      create_tags(:title => 'Title', :track => '1', :album => '', :artist => '')
      @renamer.rename.should == '1 - Title'
    end

    it 'with nils' do
      create_tags(:title => 'Title', :track => '1', :album => nil, :artist => nil)
      @renamer.rename.should == '1 - Title'
    end

    it 'with track number, artist, album and title' do
      create_tags(:title => 'Title', :track => '1', :album => 'Album', :artist => 'Artist')
      @renamer.rename.should == '1 - Artist - Album - Title'
    end
  end

  it 'should raise error without track number or title' do
    create_tags(:title => '', :track => '', :album => 'Album', :artist => 'Artist')
    lambda { @renamer.rename }.should raise_error(RuntimeError)
  end
end

