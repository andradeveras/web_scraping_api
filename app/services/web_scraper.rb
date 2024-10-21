class WebScraper
  require 'nokogiri'
  require 'open-uri' # Adicionando isso para permitir o uso de URI.open

  def self.scrape(url)
    begin
      # Pegando o conteúdo HTML da página
      html_content = URI.open(url,
        "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36").read

      # Fazendo o parse com Nokogiri
      document = Nokogiri::HTML(html_content)

      # Extraindo a marca
      brand_element = document.at_css('#VehicleBasicInformationTitle strong')
      brand = brand_element ? brand_element.text.strip : 'Marca não encontrada'
      
      # Extraindo o modelo
      model_element = document.at_css('#VehicleBasicInformationTitle span')
      model = model_element ? model_element.text.strip : 'Modelo não encontrado'

      # Extraindo o preço
      price_element = document.at_css('#vehicleSendProposalPrice')
      price = price_element ? price_element.text.strip.gsub(/[^\d]/, '').to_i : 'Preço não encontrado'

      { brand: brand, model: model, price: price }

    rescue StandardError => e
      Rails.logger.error "Erro durante o scraping: #{e.message}"
      { error: e.message } # Retorne um hash com a mensagem de erro
    end
  end
end
