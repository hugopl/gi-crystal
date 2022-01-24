require "./doc_repo"

module Generator
  module DocHelper
    @doc_repo : DocRepo?

    macro render_doc(obj)
      doc_repo.doc(io, {{ obj.id }})
    end

    macro render_doc(obj1, obj2)
      doc_repo.doc(io, {{ obj1.id }}, {{ obj2.id }})
    end

    def doc_repo : DocRepo
      @doc_repo ||= DocRepo.for(@namespace)
    end
  end
end
