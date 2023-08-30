require 'rails_helper'

RSpec.describe "Fonction du modèle d'étiquetage", type: :model do

    describe "Test de Validation" do
      let!(:user) { FactoryBot.create(:user) }
      context "Si le nom de l'étiquette est une lettre vide" do
        it 'Validation échoue' do
          label = Label.create(
            name: "",
            user_id: user.id,
          )
          expect(label).to be_valid
        end
      end

     context "Si le nom de l'étiquette a une valeur" do
       it "Validation Le succès dans" do
        label = Label.create(
          name: "étiquette",
          user_id: user.id,
        )
        expect(label).to be_valid
       end
      end
    end
end