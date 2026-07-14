import UIKit
import SwiftUI
import SwiftData
import UniformTypeIdentifiers
import Combine


@MainActor
final class ShareExtensionModel: ObservableObject {
    
    var extensionContext:
        NSExtensionContext?
    var onSaved:
        ((UUID, UUID) -> Void)?
    
    @Published
    var image: UIImage?
    
    
    @Published
    var recognizedText = ""
    
    
    @Published
    var isRecognizing = false
    
    
    @Published
    var offers: [ParsedCashbackOffer] = []
    
    
    @Published
    var persons: [ShareRepository.PersonItem] = []
    
    
    @Published
    var banks: [ShareRepository.BankItem] = []
    
    
    @Published
    var selectedPersonID: UUID?
    
    
    @Published
    var selectedBankID: UUID?
    
    
    @Published
    var errorMessage: String?
    
    
    @Published
    var saveCompleted = false
    
    
    
    private var repository: ShareRepository?
    
    
    
    func configure(
        context: ModelContext
    ) {
        
        repository =
        ShareRepository(
            context: context
        )
        
        loadPersons()
        
    }
    
    
    
    private func loadPersons() {
        
        guard
            let repository
        else {
            
            return
            
        }
        
        
        do {
            
            persons =
            try repository
                .loadPersons()
            
            
            if selectedPersonID == nil {
                
                selectedPersonID =
                persons.first?.id
                
            }
            
            
            loadBanks()
            
            
        } catch {
            
            errorMessage =
            error.localizedDescription
            
        }
        
    }
    
    
    
    func loadBanks() {
        
        guard
            let repository,
            let personID =
                selectedPersonID
        else {
            
            banks = []
            
            selectedBankID = nil
            
            return
            
        }
        
        
        
        do {
            
            banks =
            try repository
                .loadBanks(
                    ownerID: personID
                )
            
            
            if
                !banks.contains(
                    where: {
                        $0.id ==
                        selectedBankID
                    }
                )
            {
                
                selectedBankID =
                banks.first?.id
                
            }
            
            
        } catch {
            
            errorMessage =
            error.localizedDescription
            
        }
        
    }
    
    
    
    func selectPerson(
        _ id: UUID
    ) {
        
        selectedPersonID =
        id
        
        loadBanks()
        
    }
    func load(
        from extensionContext: NSExtensionContext?
    ) {

        self.extensionContext =
            extensionContext


        guard
                
            let item =
                extensionContext?
                .inputItems
                .first as? NSExtensionItem,
            
                let provider =
                item.attachments?
                .first
                
        else {
            
            return
            
        }
        
        
        
        guard
            
            provider.hasItemConformingToTypeIdentifier(
                UTType.image.identifier
            )
                
        else {
            
            return
            
        }
        
        
        
        provider.loadObject(
            ofClass: UIImage.self
        ) { object, _ in
            
            
            guard
                
                let image =
                    object as? UIImage
                    
            else {
                
                return
                
            }
            
            
            
            Task {
                
                await MainActor.run {
                    
                    self.image =
                    image
                    
                }
                
                
                
                await self.recognize(
                    image: image
                )
                
            }
            
            
        }
        
    }
    
    
    
    private func recognize(
        image: UIImage
    ) async {
        
        
        await MainActor.run {
            
            isRecognizing =
            true
            
        }
        
        
        
        defer {
            
            Task {
                
                await MainActor.run {
                    
                    isRecognizing =
                    false
                    
                }
                
            }
            
        }
        
        
        
        do {
            
            
            let text =
            try await OCRService
                .recognize(
                    image: image
                )
            
            
            
            let parsed =
            CashbackTextParser
                .parse(
                    text: text
                )
            
            
            
            await MainActor.run {
                
                
                recognizedText =
                text
                
                
                offers =
                parsed
                
                
            }
            
            
            
        } catch {
            
            
            await MainActor.run {
                
                
                errorMessage =
                error.localizedDescription
                
                
            }
            
        }
        
    }
    
    
    
    func removeOffer(
        id: UUID
    ) {
        
        
        offers.removeAll {
            
            
            $0.id ==
            id
            
            
        }
        
        
    }
    
    
    
    func updateOffer(
        id: UUID,
        category: String,
        percent: Double
    ) {
        
        
        guard
            
            let index =
                offers.firstIndex(
                    where: {
                        
                        $0.id ==
                        id
                        
                    }
                )
                
        else {
            
            return
            
        }
        
        
        
        offers[index].category =
        category
        
        
        offers[index].percent =
        percent
        
        
    }
    var canSave: Bool {

        selectedBankID != nil
        &&
        !offers.isEmpty

    }



    func save(
        month: Date = Date().startOfMonth
    ) {


        guard

            let repository,

            let bankID =
                selectedBankID

        else {

            errorMessage =
                "Не выбран банк."

            return

        }



        do {


            try repository.saveOffers(

                bankID:
                    bankID,

                month:
                    month,

                offers:
                    offers

            )
            if let personID =

                selectedPersonID {

                onSaved?(

                    personID,

                    bankID

                )

            }

        } catch {


            errorMessage =
                error.localizedDescription


        }


    }



    func clear() {


        image =
            nil


        recognizedText =
            ""


        offers =
            []


        errorMessage =
            nil


        saveCompleted =
            false


    }



    func complete(
        extensionContext:
            NSExtensionContext?
    ) {


        extensionContext?
            .completeRequest(
                returningItems: nil
            )


    }


}
