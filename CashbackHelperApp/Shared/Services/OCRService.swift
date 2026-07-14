import Foundation
import UIKit
import Vision


enum OCRService {


    static func recognize(
        image: UIImage
    ) async throws -> String {


        guard
            let cgImage =
                image.cgImage
        else {

            throw OCRError.invalidImage

        }



        return try await withCheckedThrowingContinuation {
            continuation in


                let request =
                    VNRecognizeTextRequest {


                        request, error in


                        if let error {

                            continuation
                                .resume(
                                    throwing:
                                        error
                                )

                            return

                        }



                        let observations =
                            request.results
                            as? [VNRecognizedTextObservation]
                            ?? []



                        let text =
                            observations
                                .compactMap {

                                    $0.topCandidates(
                                        1
                                    )
                                    .first?
                                    .string

                                }
                                .joined(
                                    separator:
                                        "\n"
                                )



                        continuation
                            .resume(
                                returning:
                                    text
                            )


                    }



                request.recognitionLevel =
                    .accurate



                request.recognitionLanguages =
                [
                    "ru-RU",
                    "en-US"
                ]



                let handler =
                    VNImageRequestHandler(
                        cgImage:
                            cgImage
                    )



                do {

                    try handler.perform(
                        [
                            request
                        ]
                    )

                } catch {

                    continuation
                        .resume(
                            throwing:
                                error
                        )

                }

        }

    }



    enum OCRError:
        Error {

        case invalidImage

    }


}
