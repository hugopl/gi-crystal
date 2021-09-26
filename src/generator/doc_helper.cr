require "./doc_repo"

module Generator
  module DocHelper
    @doc_repo : DocRepo?

    macro render_doc(obj)
      doc_repo.doc(io, {{ obj.id }})
    end

    def doc_repo : DocRepo
      @doc_repo ||= DocRepo.for(@namespace)
    end
  end
end
