using System;
using System.Collections.Generic;

class TuxSay
{
   static void Main(string[] args)
    {
        Console.Clear();

        string message = "BTW, I use Arch!";
        string mood = "-1";
        bool noMessage = false;

        
        if (args.Length == 0 || (args.Length > 0 && (args[0] == "-h" || args[0] == "--help")))
        {
            ShowHelp();
            return;
        }

        try
        {
            int argIndex = 0;

            
            if (args[argIndex] == "-n")
            {
                noMessage = true;
                argIndex++;
            }

            
            if (argIndex < args.Length && args[argIndex].StartsWith("-") && args[argIndex].Length == 2 && char.IsDigit(args[argIndex][1]))
            {
                int moodNum = int.Parse(args[argIndex].Substring(1));
                if (moodNum >= 1 && moodNum <= 10)
                {
                    mood = args[argIndex];
                    argIndex++;
                }
                else throw new Exception();
            }

            
            if (!noMessage && argIndex < args.Length)
            {
                message = ReconstructMessage(args, argIndex);
            }

            
            if (!noMessage)
            {
                PrintSpeechBubble(message);
            }
            PrintTux(mood);
        }
        catch
        {
            ShowHelp();
        }
    }


    static string ReconstructMessage(string[] args, int startIndex)
    {
        return string.Join(" ", args, startIndex, args.Length - startIndex);
    }

    static void ShowHelp()
    {   
        Console.WriteLine("TuxSay - Made by execRooted\n");
        Console.WriteLine("Usage:");
        Console.WriteLine("  tuxsay [flags] [mood] [message]\n");
        Console.WriteLine("Flags:");
        Console.WriteLine("  -h, --help      Show this help message");
        Console.WriteLine("  -n              Print Tux only, without any message\n");
        Console.WriteLine("Moods (-1 to -10):");
        Console.WriteLine("  -1  Normal      -2  Angry       -3  Surprised");
        Console.WriteLine("  -4  Paranoid    -5  Happy       -6  Sleepy");
        Console.WriteLine("  -7  Crying      -8  Cool        -9  Dead");
        Console.WriteLine("  -10 Wizard\n");
        Console.WriteLine("Examples:");
        Console.WriteLine("  tuxsay -3 \"Segmentation fault!\"");
        Console.WriteLine("  tuxsay -7 I deleted my node_modules");
        Console.WriteLine("  tuxsay -n           # Just shows Tux without any message");
        Console.WriteLine("  tuxsay -n -5        # Tux happy, no message");
        Console.WriteLine("Note: The order of the arguments matter! If you input tuxsay -1 -n Tux will say \"-n\"");
    }

    static void PrintSpeechBubble(string text)
    {
        
        int maxWidth = Math.Min(Console.WindowWidth - 15, 50); 
        string[] lines = SplitTextIntoLines(text, maxWidth);
        
        int maxLineLength = 0;
        foreach (string line in lines)
        {
            if (line.Length > maxLineLength) maxLineLength = line.Length;
        }

       
        Console.WriteLine(new string(' ', 15) + " " + new string('-', maxLineLength + 2));
        
       
        foreach (string line in lines)
        {
            Console.WriteLine(new string(' ', 15) + "| " + line.PadRight(maxLineLength) + " |");
        }
        
        
        Console.WriteLine(new string(' ', 15) + " " + new string('-', maxLineLength + 2));
        Console.WriteLine(new string(' ', 14) + "/" + new string(' ', maxLineLength + 2));
    }

    static string[] SplitTextIntoLines(string text, int maxWidth)
    {
        if (text.Length <= maxWidth) return new string[] { text };
        
        string[] words = text.Split(' ');
        List<string> lines = new List<string>();
        string currentLine = "";
        
        foreach (string word in words)
        {
            if ((currentLine + word).Length > maxWidth)
            {
                lines.Add(currentLine.Trim());
                currentLine = word + " ";
            }
            else
            {
                currentLine += word + " ";
            }
        }
        
        if (!string.IsNullOrWhiteSpace(currentLine))
        {
            lines.Add(currentLine.Trim());
        }
        
        return lines.ToArray();
    }

    static void PrintTux(string mood)
    {
       
        string padding = new string(' ', 5);
        
        switch (mood)
        {
            case "-1": 
                Console.WriteLine(padding + @"   .--.");
                Console.WriteLine(padding + @"  |o_o |");
                Console.WriteLine(padding + @"  |:_/ |");
                Console.WriteLine(padding + @" //   \ \");
                Console.WriteLine(padding + @"(|     | )");
                Console.WriteLine(padding + @"/'\_   _/`\");
                Console.WriteLine(padding + @"\___)=(___/");
                break;

            case "-2": 
                Console.WriteLine(padding + @"   .--.");
                Console.WriteLine(padding + @"  |><_|");
                Console.WriteLine(padding + @"  |/  \|");
                Console.WriteLine(padding + @" //   \ \");
                Console.WriteLine(padding + @"(|     | )");
                Console.WriteLine(padding + @"/'\_   _/`\");
                Console.WriteLine(padding + @"\___)=(___/");
                break;

            case "-3": 
                Console.WriteLine(padding + @"   .--.");
                Console.WriteLine(padding + @"  |O_O |");
                Console.WriteLine(padding + @"  |/ \ |");
                Console.WriteLine(padding + @" //   \ \");
                Console.WriteLine(padding + @"(|     | )");
                Console.WriteLine(padding + @"/'\_   _/`\");
                Console.WriteLine(padding + @"\___)=(___/");
                break;

            case "-4":
                Console.WriteLine(padding + @"   .--.");
                Console.WriteLine(padding + @"  |o_- |");
                Console.WriteLine(padding + @"  |/ \ |");
                Console.WriteLine(padding + @" //   \ \");
                Console.WriteLine(padding + @"(| .-. | )");
                Console.WriteLine(padding + @"/'\_   _/`\");
                Console.WriteLine(padding + @"\___)=(___/");
                break;

            case "-5": 
                Console.WriteLine(padding + @"   .--.");
                Console.WriteLine(padding + @"  |^_^ |");
                Console.WriteLine(padding + @"  |/ \ |");
                Console.WriteLine(padding + @" //   \ \");
                Console.WriteLine(padding + @"(| \_/ | )");
                Console.WriteLine(padding + @"/'\_   _/`\");
                Console.WriteLine(padding + @"\___)=(___/");
                break;

            case "-6": 
                Console.WriteLine(padding + @"   .--.");
                Console.WriteLine(padding + @"  |-_- |");
                Console.WriteLine(padding + @"  |/ \ |");
                Console.WriteLine(padding + @" //   \ \");
                Console.WriteLine(padding + @"(|  Z  | )");
                Console.WriteLine(padding + @"/'\_   _/`\");
                Console.WriteLine(padding + @"\___)=(___/");
                break;

            case "-7": 
                Console.WriteLine(padding + @"   .--.");
                Console.WriteLine(padding + @"  |T_T |");
                Console.WriteLine(padding + @"  |/ \ |");
                Console.WriteLine(padding + @" //   \ \");
                Console.WriteLine(padding + @"(| ~~~ | )");
                Console.WriteLine(padding + @"/'\_   _/`\");
                Console.WriteLine(padding + @"\___)=(___/");
                break;

            case "-8":
                Console.WriteLine(padding + @"   .--.");
                Console.WriteLine(padding + @"  |B-) |");
                Console.WriteLine(padding + @"  |/ \ |");
                Console.WriteLine(padding + @" //   \ \");
                Console.WriteLine(padding + @"(|  _  | )");
                Console.WriteLine(padding + @"/'\_   _/`\");
                Console.WriteLine(padding + @"\___)=(___/");
                break;

            case "-9": 
                Console.WriteLine(padding + @"   .--.");
                Console.WriteLine(padding + @"  |X_X |");
                Console.WriteLine(padding + @"  |/ \ |");
                Console.WriteLine(padding + @" //   \ \");
                Console.WriteLine(padding + @"(|     | )");
                Console.WriteLine(padding + @"/'\_   _/`\");
                Console.WriteLine(padding + @"\___)=(___/");
                break;

            case "-10": 
                Console.WriteLine(padding + @"   .--.");
                Console.WriteLine(padding + @"  |*-* |");
                Console.WriteLine(padding + @"  |/ \ |");
                Console.WriteLine(padding + @" //   \ \");
                Console.WriteLine(padding + @"(| _□_ | )");
                Console.WriteLine(padding + @"/'\_   _/`\");
                Console.WriteLine(padding + @"\___)=(___/");
                break;
        }
    }
}
