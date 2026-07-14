import Foundation


enum CashbackTextParser {


    static func parse(
        text: String
    ) -> [ParsedCashbackOffer] {


        let lines =
            text
                .components(
                    separatedBy:
                        .newlines
                )
                .map {

                    $0.trimmingCharacters(
                        in:
                            .whitespacesAndNewlines
                    )

                }
                .filter {

                    !$0.isEmpty

                }



        var result:
            [ParsedCashbackOffer] = []



        for line in lines {


            guard
                let percent =
                    extractPercent(
                        from:
                            line
                    )

            else {

                continue

            }



            let category =
                removePercent(
                    from:
                        line
                )



            guard
                !category.isEmpty
            else {

                continue

            }



            result.append(

                ParsedCashbackOffer(

                    category:
                        category,

                    percent:
                        percent

                )

            )


        }



        return result

    }



    private static func extractPercent(
        from text: String
    ) -> Double? {


        let pattern =
            #"(\d+(?:[.,]\d+)?)\s*%"#



        guard

            let regex =
                try? NSRegularExpression(
                    pattern:
                        pattern
                )

        else {

            return nil

        }



        let range =
            NSRange(
                text.startIndex...,
                in:
                    text
            )



        guard

            let match =
                regex.firstMatch(
                    in:
                        text,
                    range:
                        range
                )

        else {

            return nil

        }



        guard

            let percentRange =
                Range(
                    match.range(
                        at:
                            1
                    ),
                    in:
                        text
                )

        else {

            return nil

        }



        let value =
            String(
                text[
                    percentRange
                ]
            )
            .replacingOccurrences(
                of:
                    ",",
                with:
                    "."
            )



        return Double(
            value
        )

    }



    private static func removePercent(
        from text: String
    ) -> String {


        let pattern =
            #"(\d+(?:[.,]\d+)?)\s*%"#



        return text
            .replacingOccurrences(
                of:
                    pattern,
                with:
                    "",
                options:
                    .regularExpression
            )
            .trimmingCharacters(
                in:
                    .whitespacesAndNewlines
            )

    }


}
