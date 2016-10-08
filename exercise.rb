    require 'open-uri'

    def generate_words_sequences(input_words)

        words_sequences = { sequences: [], words: [], occurrences: [] }

        # read each word from input_words
        input_words.each do |word|

            # words with size less than 4 are not considered
            if (word.size >= 4)

                # shift every 4 letter combination from a word
                for index in 0..(word.size-4)

                    sequence = word[index..index+3]

                    # consider only sequences composed by 4 letters
                    if sequence =~ /[[:alpha:]]{4}/

                        index =  words_sequences[:sequences].index(sequence)

                        # not first time sequence ? increment corresponding occurrence variable
                        if index
                            words_sequences[:occurrences][index] = words_sequences[:occurrences][index] + 1
                        # first time sequence ? register sequence, word and number of occurrences initially as zero
                        else                
                            words_sequences[:sequences].push(sequence)
                            words_sequences[:words].push(word)
                            words_sequences[:occurrences].push(0)
                        end
                        
                    end
                end

            end

        end

        return words_sequences
    end

    # select sequences and words to be saved in file
    def select_sequences_and_words(words_sequences)

        result = { sequence_file_content: "", word_file_content: "" }

        # navigate through each sequence in alphabetical order following provided example
        for sequence in words_sequences[:sequences].sort
            index = words_sequences[:sequences].index sequence

            # check for sequences that occurred only once
            if ( words_sequences[:occurrences][index] == 0)
                # concatenate output message
                result[:sequence_file_content] <<  words_sequences[:sequences][index] + "\n"
                result[:word_file_content] <<   words_sequences[:words][index] + "\n"
            end
        end

        return result
    end

    # write content to file 
    def write_file(file_name, file_content)
        File.open(file_name,"w") do |file|
            file.write file_content
        end
    end

    def read_array_from_url(url)
        input_content = open(url) { |file| file.read }
        input_content.split
    end

    input_words = read_array_from_url('https://dl.dropboxusercontent.com/u/14065136/dictionary.txt')
    words_sequences = generate_words_sequences(input_words)
    result = select_sequences_and_words(words_sequences)
    write_file("sequences", result[:sequence_file_content])
    write_file("words", result[:word_file_content])

