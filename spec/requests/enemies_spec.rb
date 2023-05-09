require 'rails_helper'

RSpec.describe "Enemies", type: :request do
  describe "PUT /enemies" do
    context 'when the enemy exists' do
      let(:enemy) { create(:enemy) }
      let(:enemy_attributes) { attributes_for(:enemy) }
      before(:each) { put "/enemies/#{enemy.id}", params: enemy_attributes }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'updates the record' do
        expect(enemy.reload).to have_attributes(enemy_attributes)
      end

      it 'returns the enemy updated' do
        expect(enemy.reload).to have_attributes(json.except('created_at', 'updated_at'))
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

      it 'returns a not found message' do
        delete enemy_path(0)

        expect(response.body).to match(/Couldn't find Enemy/)
      end
    end
  end
end
