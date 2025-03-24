import re

# Define a custom regex pattern for valid words
# valid_pattern = re.compile(r'^(A(i(g|n|d)|l(g|q|o)|d(lómë)?|q(ua)?))$')
# valid_pattern = re.compile(r'^(A(i(g|n|d)|l(g|q|o)|d(lómë)?|q(ua)?))$')
# Add the re.IGNORECASE flag to make it case-insensitive
# valid_pattern = re.compile(r'^(A(i(g|n|d)|l(g|q|o)|d(lómë)?|q(ua)?)).*$', re.IGNORECASE)
valid_pattern = re.compile(r'^(Aiglos|Ainu|Aid|Alg|Alq|Alo|Alda(lómë)?|Alqua?)$')

def validate_word(word):
    return bool(valid_pattern.match(word))

def main():
    while True:
        print("\nChoose an option:")
        print("1. Test a list of valid words")
        print("2. Test a list of invalid words")
        print("3. Enter a custom word")
        print("4. Exit")
        
        choice = input("Enter your choice: ")
        
        if choice == '1':
            valid_words = ["Aiglos", "Ainu", "Alda", "Aldalómë", "Alqua"]
            for word in valid_words:
                print(f"{word}: {validate_word(word)}")
        
        elif choice == '2':
            invalid_words = ["Axyz", "Bla", "Test", "123", "aiglos"]
            for word in invalid_words:
                print(f"{word}: {validate_word(word)}")
        
        elif choice == '3':
            custom_word = input("Enter a word to test: ")
            print(f"{custom_word}: {validate_word(custom_word)}")
        
        elif choice == '4':
            print("Exiting...")
            break
        
        else:
            print("Invalid choice. Please enter 1, 2, 3, or 4.")

if __name__ == "__main__":
    main()
