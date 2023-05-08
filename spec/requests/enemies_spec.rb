require 'rails_helper'

RSpec.describe "Enemies", type: :request do
  describe "PUT /enemies" do
    context 'when the enemy exists' do
      it 'return status code 200' do
        enemy = create(:enemy)
        enemy_attributes = attributes_for(:enemy)
        put "/enemies/#{enemy.id}", params: enemy_attributes

        expect(response).to have_http_status(200)
      end

      # verifica se de fato a versão mais recente do enemy no banco de
      # dados contém os mesmos atributos que passamos.
      it 'updates the record' do
        enemy = create(:enemy)
        enemy_attributes = attributes_for(:enemy)
        put "/enemies/#{enemy.id}", params: enemy_attributes

        expect(enemy.reload).to have_attributes(enemy_attributes)
      end
      # verifica se o retorno via json está correto
      it 'returns the enemy updated' do
        enemy = create(:enemy)
        enemy_attributes = attributes_for(:enemy)
        put "/enemies/#{enemy.id}", params: enemy_attributes

        # JSON.parse converte os dados da resposta de jon para um hash
        json_response = JSON.parse(response.body)
        # ignora os atributos de data de criação e atualização
        expect(enemy.reload).to have_attributes(json_response.except('created_at', 'updated_at'))
      end
    end

    context 'when the enemy does not exist' do
      it 'returns status code 404' do
        # enviando parâmetros para um inimigo inexistente | id 0 não existe
        put '/enemies/0', params: attributes_for(:enemy)
        expect(response).to have_http_status(404)
      end
      it 'returns a not found message' do
        put '/enemies/0', params: attributes_for(:enemy)
        expect(response.body).to match(/Couldn't find Enemy/)
      end
    end
  end

  describe 'DELETE /enemies' do
    context 'when the enemy exists' do
      it 'return status code 204' do
        enemy = create(:enemy)
        delete "/enemies/#{enemy.id}"

        expect(response).to have_http_status(204)
      end

      it 'destroy the record' do
        enemy = create(:enemy)
        # utiliza um helper para representar a rota do enemy igual ao teste anterior
        delete enemy_path(enemy)

        # o enemy.reload lança um erro caso o inimigo não exista
        expect { enemy.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when the enemy does not exist' do
      it 'return status code 404' do
        delete '/enemies/0'

        expect(response).to have_http_status(404)
      end
    end
  end
end
