require_relative 'main'

describe 'Main' do
  main = Main.new

  # bundle exec rspec -e 'parse' main_spec.rb
  it 'parse' do
    html = Nokogiri::HTML(File.open('example.html').read.toutf8)
    array = main.extract_image_url_list html
    expect(array.length).to eq(20)
  end
end
