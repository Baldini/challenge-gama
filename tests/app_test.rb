# encoding: UTF-8
require_relative '../app'
require 'minitest/autorun'
require 'rack/test'
require 'httparty'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_home_busca_de_endereco

    get '/'
    assert_match /Busca de Endereço/, last_response.body

  end

  def test_busca_de_endereco

    endereco = 'Rua Casa do Ator, 275'.gsub(' ', '+')
    escaped  = URI.escape(endereco)
    url      = "http://maps.google.com/maps/api/geocode/json?address=#{escaped}"
    response = HTTParty.get(url)
    parsed   = JSON.parse(response.body)['results']

    get '/?url=Rua+casa+do+ator%2C275'
    assert_match /#{parsed[0]['address_components'][1]['long_name']}/, last_response.body

  end

end
