require_relative '../../lib/togglv8'
require 'oj'

describe "Clients" do
  before :all do
    @toggl = Toggl::V8.new(Testing::API_TOKEN)
    @workspaces = @toggl.workspaces
    @workspace_id = @workspaces.first['id']
  end

  it 'receives {} if there are no workspace clients' do
    client = @toggl.clients(@workspace_id)
    expect(client).to be {}
  end

  context 'new client' do
    before :all do
      @client = @toggl.create_client({ name: 'client1', wid: @workspace_id })
    end

    after :all do
      TogglV8SpecHelper.delete_all_clients(@toggl)
    end

    it 'creates a client' do
      expect(@client).to_not be nil
      expect(@client['name']).to eq 'client1'
      expect(@client['notes']).to eq nil
      expect(@client['wid']).to eq @workspace_id
    end

    it 'gets client data' do
      client = @toggl.get_client(@client['id'])
      expect(client).to_not be nil
      expect(client['name']).to eq @client['name']
      expect(client['wid']).to eq @client['wid']
      expect(client['notes']).to eq @client['notes']
      expect(client['at']).to_not be nil
    end

    it 'updates client data' do
      new_values = {
        'name' => 'CLIENT-NEW',
        'notes' => 'NOTES-NEW',
      }

      client = @toggl.update_client(@client['id'], new_values)
      expect(client).to include(new_values)
    end

    it 'updates Pro project data', :pro_account do
      new_values = {
        hrate: '7.77',
        cur: 'USD',
      }
      client = @toggl.update_client(@client['id'], new_values)
      expect(client).to include(new_values)
    end

    context 'client projects' do
      before :all do
        @project = @toggl.create_project({ name: 'project2', wid: @workspace_id, cid: @client['id'] })
      end

      after :all do
        TogglV8SpecHelper.delete_all_projects(@toggl)
      end

      it 'receives {} if there are no client projects' do
        projects = @toggl.get_client_projects(@client['id'])
        expect(projects).to be {}
      end

      it 'gets client projects' do
        projects = @toggl.get_client_projects(@client['id'])
        expect(projects).to be {}
      end
    end

  end
end