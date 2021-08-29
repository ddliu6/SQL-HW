using System;
using System.Collections.Generic;
using System.Text;

namespace ClassDesign
{
    class Menu
    {
        public string Print()
        {
            string[] names = Enum.GetNames(typeof(AdventurerOptions));
            int[] values = (int[])Enum.GetValues(typeof(AdventurerOptions));
            for (int i = 0; i < names.Length; ++i)
                Console.WriteLine($"Press {values[i]} for {names[i]}");
            Console.Write("Enter your choice => ");
            return Console.ReadLine();
        }
    }
}
