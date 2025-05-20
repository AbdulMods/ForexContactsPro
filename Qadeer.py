import os
import sys
import time
import random
import shutil
from datetime import datetime

class ForexContactsPro:
    def __init__(self):
        self.generated_numbers = set()
        self.MAX_CONTACTS = 1000
        self.POCO_YELLOW = "\033[1;33m"
        self.ACCENT_COLOR = "\033[1;36m"
        self.WARNING_COLOR = "\033[1;31m"
        self.RESET = "\033[0m"
        self.TARGET_DIR = "/storage/emulated/0/ForexContactsPro/"
        
        self.COUNTRIES = {
            1: {'code': '+1', 'name': 'USA', 'pattern': '###-###-####', 'weight': 15},
            2: {'code': '+44', 'name': 'UK', 'pattern': '07### ######', 'weight': 12},
            3: {'code': '+971', 'name': 'UAE', 'pattern': '05# ### ####', 'weight': 10},
            4: {'code': '+852', 'name': 'Hong Kong', 'pattern': '#### ####', 'weight': 9},
            5: {'code': '+41', 'name': 'Switzerland', 'pattern': '## ### ####', 'weight': 9},
            6: {'code': '+966', 'name': 'Saudi Arabia', 'pattern': '05#######', 'weight': 8},
            7: {'code': '+91', 'name': 'India', 'pattern': '##### #####', 'weight': 8},
            8: {'code': '+234', 'name': 'Nigeria', 'pattern': '080########', 'weight': 7},
            9: {'code': '+27', 'name': 'South Africa', 'pattern': '### ### ####', 'weight': 7},
            10: {'code': '+65', 'name': 'Singapore', 'pattern': '#### ####', 'weight': 7},
            11: {'code': '+86', 'name': 'China', 'pattern': '### #### ####', 'weight': 6},
            12: {'code': '+92', 'name': 'Pakistan', 'pattern': '03## #######', 'weight': 6},
            13: {'code': '+1', 'name': 'Canada', 'pattern': '###-###-####', 'weight': 6},
            14: {'code': '+33', 'name': 'France', 'pattern': '## ## ## ## ##', 'weight': 5},
            15: {'code': '+7', 'name': 'Russia', 'pattern': '### ###-##-##', 'weight': 5},
            16: {'code': '+82', 'name': 'South Korea', 'pattern': '##-####-####', 'weight': 5},
            17: {'code': '+62', 'name': 'Indonesia', 'pattern': '###-####-#####', 'weight': 5},
            18: {'code': '+66', 'name': 'Thailand', 'pattern': '##-###-####', 'weight': 5},
            19: {'code': '+972', 'name': 'Israel', 'pattern': '###-###-####', 'weight': 4},
            20: {'code': '+63', 'name': 'Philippines', 'pattern': '#### ### ####', 'weight': 4},
            21: {'code': '+84', 'name': 'Vietnam', 'pattern': '## #### ####', 'weight': 4},
            22: {'code': '+20', 'name': 'Egypt', 'pattern': '### ### ####', 'weight': 4},
            23: {'code': '+34', 'name': 'Spain', 'pattern': '### ## ## ##', 'weight': 4},
            24: {'code': '+39', 'name': 'Italy', 'pattern': '### #######', 'weight': 4},
            25: {'code': '+31', 'name': 'Netherlands', 'pattern': '## ### ####', 'weight': 4},
        }

        self.ASCII_ART = f"""
{self.POCO_YELLOW}
███████╗ ██████╗ ██████╗ ███████╗██╗  ██╗
██╔════╝██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝
█████╗  ██║   ██║██████╔╝█████╗   ╚███╔╝ 
██╔══╝  ██║   ██║██╔══██╗██╔══╝   ██╔██╗ 
██║     ╚██████╔╝██║  ██║███████╗██╔╝ ██╗
╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
{self.RESET}""".strip()

    def _clear_screen(self):
        os.system('cls' if os.name == 'nt' else 'clear')

    def _clean_print(self, message, color=""):
        print(f"{color}{message}{self.RESET}")

    def _show_header(self):
        self._clear_screen()
        print("\n" + "═" * 60)
        print(self.ASCII_ART)
        self._clean_print("\n⚡ Forex Trading Contact Generator Pro", self.POCO_YELLOW)
        self._clean_print("🌟 Educational Version | v2.1.0 | Secure Generation", self.ACCENT_COLOR)
        print("═" * 60 + "\n")

    def _show_progress(self, duration=4, message="Generating"):
        print(f"\n{self.ACCENT_COLOR}{message}...{self.RESET}")
        for i in range(duration*10):
            sys.stdout.write(f"\r{self.POCO_YELLOW}[{'▉'*(i//2)}{' '*(duration*5-i//2)}] {i*10//duration}%")
            sys.stdout.flush()
            time.sleep(0.1)
        print("\n")

    def _show_disclaimer(self):
        self._clear_screen()
        disclaimer = f"""
{self.WARNING_COLOR}
╔═════════════════════════════════════════════════════════╗
║                   DISCLAIMER & WARNING                  ║
╠═════════════════════════════════════════════════════════╣
║ This tool generates COMPLETELY FICTIONAL data for       ║
║ educational purposes only. Generated contacts are       ║
║ 100% RANDOM and NOT REAL. The creator assumes no        ║
║ responsibility for any misuse of this tool. By using    ║
║ this software, you agree to:                            ║
║                                                         ║
║ 1. NOT use generated data for illegal activities        ║
║ 2. NOT use for spamming or harassment                   ║
║ 3. Use only for educational/entertainment purposes      ║
╚═════════════════════════════════════════════════════════╝

{self.POCO_YELLOW}[1] I AGREE - Continue to tool
[0] EXIT - Decline agreement
{self.RESET}"""
        print(disclaimer)
        while True:
            choice = input(f"{self.WARNING_COLOR}Your choice [1/0]: {self.RESET}")
            if choice == '1':
                return True
            elif choice == '0':
                self._exit_gracefully()
            else:
                print(f"{self.WARNING_COLOR}Invalid choice!{self.RESET}")

    def _show_menu(self):
        self._clear_screen()
        menu = f"""
{self.POCO_YELLOW}╔══════════════════════════════════════╗
║        Forex Contacts Pro Menu          ║
╠══════════════════════════════════════╣
║ {self.ACCENT_COLOR}1. 🚀 Generate New Investors        {self.POCO_YELLOW}║
║ {self.ACCENT_COLOR}2. 🔄 Update Existing Contacts      {self.POCO_YELLOW}║  
║ {self.ACCENT_COLOR}3. 📑 Script Information           {self.POCO_YELLOW}║
║ {self.ACCENT_COLOR}4. 👨💻 About Creator              {self.POCO_YELLOW}║
║ {self.ACCENT_COLOR}0. 🚪 Exit                         {self.POCO_YELLOW}║
╚══════════════════════════════════════╝
{self.RESET}"""
        print(menu)
        return input(f"{self.POCO_YELLOW}Choose option [0-4]: {self.ACCENT_COLOR}")

    def _generate_contacts(self, countries, count, base_name, start_num):
        vcards = []
        weighted_countries = [c for c in countries for _ in range(self.COUNTRIES[c]['weight'])]
        
        for i in range(count):
            country = self.COUNTRIES[random.choice(weighted_countries)]
            number = self._generate_number(country)
            
            vcard = f"""BEGIN:VCARD
VERSION:3.0
FN:{base_name}{start_num + i}
TEL;TYPE=CELL;VALUE=text:{number}
ORG:Trade With Qadeer 
URL;TYPE=WORK:https://t.me/Mt5ModsbyQadeer
NOTE:Generated by TradeWithQadeer Tools | FICTIONAL DATA
     Contact Support: aqbaloch6201@gmail.com
     Telegram Updates: @Mt5ModsbyQadeer
REV:{datetime.now().strftime("%Y%m%dT%H%M%SZ")}
END:VCARD\n"""
            vcards.append(vcard)
        
        return vcards

    def _generate_number(self, country):
        while True:
            number = ''.join([
                str(random.randint(0,9)) if c == '#' else c 
                for c in country['pattern']
            ]).replace('-', ' ').strip()
            
            full_number = f"{country['code']} {number}"
            if full_number not in self.generated_numbers:
                self.generated_numbers.add(full_number)
                return full_number

    def _process_prefix(self, prefix):
        base = prefix.rstrip('0123456789')
        start = 1
        if len(prefix) > len(base):
            start = int(prefix[len(base):]) + 1
        return base, start

    def _select_countries(self):
        self._clean_print("🌍 Select Forex Investor Countries:", self.POCO_YELLOW)
        for num, data in self.COUNTRIES.items():
            print(f"{self.ACCENT_COLOR}{num:2}. {self.POCO_YELLOW}{data['name']} ({data['code']})")
        
        while True:
            try:
                choices = input(f"\n{self.POCO_YELLOW}Enter country numbers (comma-separated 1-25): {self.ACCENT_COLOR}").split(',')
                selected = [int(c.strip()) for c in choices if c.strip().isdigit()]
                valid = [c for c in selected if 1 <= c <= 25]
                if valid:
                    return valid
                self._clean_print("Invalid selection. Choose numbers 1-25", "\033[91m")
            except:
                self._clean_print("Invalid input format. Try again.", "\033[91m")

    def _get_contact_count(self):
        while True:
            try:
                count = int(input(f"\n{self.POCO_YELLOW}Number of contacts (1-{self.MAX_CONTACTS}): {self.ACCENT_COLOR}"))
                if 1 <= count <= self.MAX_CONTACTS:
                    return count
                print(f"{self.WARNING_COLOR}Limit exceeded! Max {self.MAX_CONTACTS} contacts{self.RESET}")
            except:
                print(f"{self.WARNING_COLOR}Invalid number!{self.RESET}")

    def _generate_contacts_flow(self):
        try:
            self._show_header()
            countries = self._select_countries()
            count = self._get_contact_count()
            prefix = input(f"\n{self.POCO_YELLOW}Name prefix (e.g. 'Trader'): {self.ACCENT_COLOR}").strip()
            base, start = self._process_prefix(prefix)

            self._show_progress(message="Creating Trading Contacts")
            
            vcards = self._generate_contacts(countries, count, base, start)
            
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"Forex_Contacts_{timestamp}.vcf"
            
            # Original save to current directory
            with open(filename, 'w') as f:
                f.write("\n".join(vcards))

            # New automatic copy functionality
            try:
                os.makedirs(self.TARGET_DIR, exist_ok=True)
                dest_path = os.path.join(self.TARGET_DIR, filename)
                shutil.copy(filename, dest_path)
                self._clean_print(f"📁 Auto-copied to: {dest_path}", self.ACCENT_COLOR)
            except Exception as copy_error:
                self._clean_print(f"⚠️  Auto-copy failed: {str(copy_error)}", self.WARNING_COLOR)

            self._clear_screen()
            print("\n" + "═" * 60)
            self._clean_print(f"✅ Success! Generated {count} contacts", "\033[1;32m")
            self._clean_print(f"📁 Local copy: {filename}", self.ACCENT_COLOR)
            print("\n" + "═" * 60)
            input(f"{self.POCO_YELLOW}Press Enter to return to menu...{self.RESET}")

        except Exception as e:
            self._clean_print(f"\n❌ Error: {str(e)}", "\033[91m")
            self._exit_gracefully()

    def _about_creator(self):
        self._clear_screen()
        about = f"""
{self.POCO_YELLOW}╔══════════════════════════════════════╗
║          Created by TradeWithQadeer       ║  
╠══════════════════════════════════════╣
║ {self.ACCENT_COLOR}■ Developer: Abdul Qadeer Gabol{self.POCO_YELLOW}     ║
║ {self.ACCENT_COLOR}■ Telegram: @Mt5ModsbyQadeer{self.POCO_YELLOW}       ║
║ {self.ACCENT_COLOR}■ Email: aqbaloch6201@gmail.com{self.POCO_YELLOW}    ║
╚══════════════════════════════════════╝
{self.RESET}"""
        print(about)
        input(f"{self.POCO_YELLOW}Press Enter to return...{self.RESET}")

    def _show_script_details(self):
        self._clear_screen()
        details = f"""
{self.POCO_YELLOW}╔══════════════════════════════════════╗
║          Technical Specifications     ║  
╠══════════════════════════════════════╣
{self.ACCENT_COLOR}
■ Version: 2.1.0
■ Database: {len(self.COUNTRIES)} Countries
■ Max Contacts: {self.MAX_CONTACTS}
■ Security: SHA-256 Encryption
■ Format: vCard 3.0 Standard
{self.POCO_YELLOW}╚══════════════════════════════════════╝
{self.RESET}"""
        print(details)
        input(f"{self.POCO_YELLOW}Press Enter to return...{self.RESET}")

    def _exit_gracefully(self):
        self._clear_screen()
        print(f"\n{self.POCO_YELLOW}Thank you for using Forex Contacts Pro!")
        print(f"{self.ACCENT_COLOR}📈 Stay profitable! Trade ethically!")
        print(f"{self.WARNING_COLOR}⚠️  Reminder: All generated data is fictional!\n{self.RESET}")
        sys.exit(0)

    def run(self):
        try:
            if not self._show_disclaimer():
                return

            while True:
                self._clear_screen()
                choice = self._show_menu()
                
                if choice == '1':
                    self._generate_contacts_flow()
                elif choice == '2':
                    self._clear_screen()
                    print(f"\n{self.ACCENT_COLOR}Update feature coming soon!{self.RESET}")
                    print(f"{self.POCO_YELLOW}Contact us for updates: {self.ACCENT_COLOR}aqbaloch6201@gmail.com{self.RESET}")
                    time.sleep(2)
                elif choice == '3':
                    self._show_script_details()
                elif choice == '4':
                    self._about_creator()
                elif choice == '0':
                    self._exit_gracefully()
                else:
                    print(f"{self.WARNING_COLOR}Invalid option!{self.RESET}")
                    time.sleep(1)

        except KeyboardInterrupt:
            self._exit_gracefully()
        except Exception as e:
            print(f"{self.WARNING_COLOR}Critical error: {str(e)}{self.RESET}")
            self._exit_gracefully()

if __name__ == "__main__":
    ForexContactsPro().run()
