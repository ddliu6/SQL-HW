using System;
using System.Collections.Generic;
using System.Text;

namespace ClassDesign
{
    class Dashboard
    {
        public void Run()
        {
            Menu menu = new Menu();
            string choice = menu.Print();
            AdventurerFactory advFactory = new AdventurerFactory();
            BaseAdventurer baseAdventurer = advFactory.GetObject(choice);
            if (baseAdventurer != null)
                baseAdventurer.LogInfo();
            
        }
    }
}
