module TogglV8
  class API

    ##
    # ---------
    # :section: Clients
    #
    # name  : The name of the client (string, required, unique in workspace)
    # wid   : workspace ID, where the client will be used (integer, required)
    # notes : Notes for the client (string, not required)
    # at    : timestamp that is sent in the response, indicates the time client was last updated

    def create_client(params)
      requireParams(params, ['name', 'wid'])
      post "clients", { 'client' => params }
    end

    def get_client(client_id)
      get "clients/#{client_id}"
    end

    def update_client(client_id, params)
      put "clients/#{client_id}", { 'client' => params }
    end

    def delete_client(client_id)
      delete "clients/#{client_id}"
    end

    def get_client_projects(client_id, params={})
      allowed      = ['active']
      query_params = params.select { |k,v| allowed.include? k }

      get "clients/#{client_id}/projects", query_params
    end
  end
end
