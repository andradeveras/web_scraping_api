class ScrapingController < ApplicationController
  def scrape
    Rails.logger.info "Chamando o scrape com a URL: #{params[:url]}"

    url = params[:url]
    car_data = WebScraper.scrape(url)

    if car_data.present?
      car = Car.new(car_data)
      if car.save
        render json: { status: 'success', car: car }, status: :created
      else
        render json: { status: 'error', errors: car.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { status: 'error', message: 'Falha ao realizar scraping.' }, status: :unprocessable_entity
    end
  end

  def cars
    url = params[:url]
    if url.present?
      car_data = WebScraper.scrape(url)

      if car_data.present?
        render json: car_data, status: :ok
      else
        render json: { error: 'Não foi possível realizar o scraping dos dados.' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'URL não fornecida.' }, status: :bad_request
    end
  end

  private

  # Método privado para encapsular a lógica de scraping e criação do carro
  def scrape_and_create_car(url)
    car_data = WebScraper.scrape(url)
    Rails.logger.info "Dados do carro extraídos: #{car_data.inspect}"
  
    if car_data.present? && car_data[:brand].present? && car_data[:model].present? && car_data[:price].present?
      car = Car.new(car_data)
      if car.save
        Rails.logger.info "Carro criado com sucesso: #{car.inspect}"
        car
      else
        Rails.logger.error "Erro ao salvar o carro: #{car.errors.full_messages}"
        nil
      end
    else
      Rails.logger.error "Dados de carro incompletos ou não encontrados para a URL: #{url}"
      nil
    end
  end  
end
