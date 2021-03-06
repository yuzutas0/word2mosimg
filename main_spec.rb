require_relative 'main'

# TODO: fix
describe 'Main' do
  main = Main.new

  # bundle exec rspec -e 'search' main_spec.rb
  # attention: result can change with google responses other images
  it 'search' do
    html = main.search 'test'
    array = main.parse html
    expect(array.length).to eq(20)
  end

  # bundle exec rspec -e 'parse' main_spec.rb
  it 'parse' do
    html = Nokogiri::HTML(File.open('example/render.html').read.toutf8)
    array = main.parse html
    expect(array.length).to eq(20)
  end

  # TODO: Test for save images
end
