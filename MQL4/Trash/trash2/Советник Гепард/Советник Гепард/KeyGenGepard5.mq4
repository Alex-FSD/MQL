//+------------------------------------------------------------------+
//|                                                     BANDORIY.mq4 |
//|                        Copyright © 2010, BANDORIY Software Corp. |
//|                                        http://www.goodservice.su |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, BANDORIY Software Corp."
#property link      "http://www.goodservice.su"

extern int AccNum = 11111111;

int init() {
   double gd_2560;
   string gs_2568;
   double ld_60;
   int li_4;
   string ls_52;
   int li_68;
//   if (!(IsDemo() || IsTesting() || IsOptimization())) {
 gd_2560 = AccountNumber();
   gs_2568 = AccountNumber();
   if (!(IsDemo() || IsTesting() || IsOptimization())) {
      if (StringLen(gs_2568) > 2) ls_52 = StringSubstr(gs_2568, 1, StringLen(gs_2568) - 2);
      else ls_52 = gs_2568;
      li_68 = StrToInteger(ls_52);
      li_68 = li_68 % 177 + 177;
      ld_60 = li_68 * li_68;
      li_4 = 0;
      for (int li_0 = 0; li_0 < StringLen(gs_2568); li_0 += 2) {
         ls_52 = StringSubstr(gs_2568, li_0, 1);
         li_68 = StrToInteger(ls_52);
         if (li_68 != 0) {
            if (li_4 == 0) ld_60 *= li_68;
            else ld_60 += li_68;
         }
         li_4 = 1 - li_4;
      }
      for (li_0 = 1; li_0 < StringLen(gs_2568); li_0 += 2) {
         ls_52 = StringSubstr(gs_2568, li_0, 1);
         li_68 = StrToInteger(ls_52);
         if (li_68 != 0) {
            if (li_4 == 0) ld_60 *= li_68;
            else ld_60 += li_68;
         }
         li_4 = 1 - li_4;
       }
      
 }
 
 Print("Your key:",ld_60);
 }


int start() 
{
}