require 'rails_helper'

RSpec.describe 'Fonction de gestion des tâches', type: :system do

  describe "Fonction d'enregistrement" do
    context "Lors de l'enregistrement d'une tâche" do
      it "La tâche enregistrée s'affiche" do
        # Enregistrer une tâche à utiliser dans le test
        @task=FactoryBot.create(:second_task, title: 'Manga', content: 'Naruto')
        # Passer à l'écran de détail des tâches
        visit task_path(@task)
        # Attendez (confirmez / attendez) que la chaîne de caractères "Naruto" soit incluse dans la page visitée (dans ce cas, l'écran de détails des tâches).
        expect(page).to have_content 'Naruto'
        expect(page).to have_content 'Manga'
        # Si le résultat de expect est "true", le résultat du test est affiché comme un succès, et si le résultat de expect est "false", le résultat du test est affiché comme un échec.
      end
    end
  end


  describe 'Fonction daffichage de liste' do
    # Les données de test peuvent être partagées par plusieurs tests en définissant les données de test comme des variables à l'aide de let !
    let!(:task1) { FactoryBot.create(:task, title: 'task_title') }
    let!(:task2) { FactoryBot.create(:second_task, title: 'second_task_title') }
    let!(:task3) { FactoryBot.create(:third_task, title: 'third_task_title') }
    # Le code avant est exécuté au moment où le contexte est exécuté, comme "lors du passage à l'écran de liste" ou "lorsque les tâches sont organisées par ordre décroissant de date de création".
    before do
      visit tasks_path

      # Si le résultat de expect est "true", le résultat du test est affiché comme un succès, et si le résultat de expect est "false", le résultat du test est affiché comme un échec.
      task_list = all('body tr')
        
      expect(task_list[1]).to have_text(task1.title)
      expect(task_list[2]).to have_text(task2.title)
      expect(task_list[3]).to have_text(task3.title)

    end

    context "Lors de la transition vers l'écran de liste" do
      it "Une liste des tâches enregistrées s'affiche" do
        # Attendez (confirmez / attendez) que la chaîne de caractères "création de document" soit incluse dans la page visitée (dans ce cas, l'écran de la liste des tâches).
        expect(page).to have_content 'task_title'
      end
    end

    context 'Si une nouvelle tâche est créée' do
      it 'La nouvelle tâche saffiche en haut' do
        task_list = all('body tr')
        expect(task_list[1]).to have_text(task1.title)
      end
    end
  end

  describe 'Fonction daffichage détaillée' do
    context "Lors de la transition vers un écran de détails de tâche" do
      it "Le contenu de la tâche s'affiche" do
        # Enregistrer une tâche à utiliser dans le test
        @task=FactoryBot.create(:second_task, title: 'Manga', content: 'Naruto')
        # Passer à l'écran de détail des tâches
        visit task_path(@task)
        # Attendez (confirmez / attendez) que la chaîne de caractères "Naruto" soit incluse dans la page visitée (dans ce cas, l'écran de détails des tâches).
        expect(page).to have_content 'Naruto'
        # Si le résultat de expect est "true", le résultat du test est affiché comme un succès, et si le résultat de expect est "false", le résultat du test est affiché comme un échec.
      end
    end
  end

end