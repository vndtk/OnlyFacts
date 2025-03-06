import Foundation

class FactsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var displayErrorMessage = false
    @Published var errorMessage: String?

    @Published var facts: [Fact] = []
    @Published var categories: [FactCategory] = []
    
    private let supabase = SupabaseService.shared
    
    @MainActor
    func getFacts() async {
        defer { isLoading = false }

        do {
            isLoading = true
            // let facts = try await supabase.getFacts()
            // if let facts = facts {
            //     self.facts = facts
            // }

            if let facts = try await supabase.getFacts() {
                self.facts = facts
            }

        } catch SupabaseError.failedToGetFacts {
            errorMessage = "Issue fetching facts. Please try again later."
        } catch {
            errorMessage = "An unexpected error occurred. Please try again later."
        }
    }

    @MainActor
    func createFact(content: String, category: String) async {
        defer { isLoading = false }
        
        do {
            isLoading = true
            let fact = Fact(
                id: "", 
                content: content, 
                icon: "globe.americas.fill",
                category: category,
                likes: 0,
                dislikes: 0,
                author: "",
                image: nil
            )

            try await supabase.createFact(fact: fact)

        } catch SupabaseError.failedToCreateFact {
            errorMessage = "Issue creating fact. Please try again later."
        } catch {
            errorMessage = "An unexpected error occurred. Please try again later."
        }
    }
}
