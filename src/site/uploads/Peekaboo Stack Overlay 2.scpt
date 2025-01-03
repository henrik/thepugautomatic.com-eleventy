FasdUAS 1.101.10   ��   ��    k             l      ��  ��   ��
"Peekaboo Stack Overlay" by Henrik Nyh <http://henrik.nyh.se/2007/11/hide-leopard-stack-overlays-in-finder>
This Folder Action handler is triggered whenever items are added to or removed from the attached folder (and indirectly when they're renamed).
When that happens, it will juggle things around to make the stack reload while the icon is non-hidden, and then hides it again. The end result is that you can keep the icon file hidden in the Finder but still see it overlayed on the stack (and in the expanded stack, alas).
The juggling also ensures that the icon is the most recently added item, so that it will sort on top in stacks with that order.
This script assumes an icon named " Icon" (with the space, so it sorts first in alphabetical stacks).
     � 	 	� 
 " P e e k a b o o   S t a c k   O v e r l a y "   b y   H e n r i k   N y h   < h t t p : / / h e n r i k . n y h . s e / 2 0 0 7 / 1 1 / h i d e - l e o p a r d - s t a c k - o v e r l a y s - i n - f i n d e r > 
 T h i s   F o l d e r   A c t i o n   h a n d l e r   i s   t r i g g e r e d   w h e n e v e r   i t e m s   a r e   a d d e d   t o   o r   r e m o v e d   f r o m   t h e   a t t a c h e d   f o l d e r   ( a n d   i n d i r e c t l y   w h e n   t h e y ' r e   r e n a m e d ) . 
 W h e n   t h a t   h a p p e n s ,   i t   w i l l   j u g g l e   t h i n g s   a r o u n d   t o   m a k e   t h e   s t a c k   r e l o a d   w h i l e   t h e   i c o n   i s   n o n - h i d d e n ,   a n d   t h e n   h i d e s   i t   a g a i n .   T h e   e n d   r e s u l t   i s   t h a t   y o u   c a n   k e e p   t h e   i c o n   f i l e   h i d d e n   i n   t h e   F i n d e r   b u t   s t i l l   s e e   i t   o v e r l a y e d   o n   t h e   s t a c k   ( a n d   i n   t h e   e x p a n d e d   s t a c k ,   a l a s ) . 
 T h e   j u g g l i n g   a l s o   e n s u r e s   t h a t   t h e   i c o n   i s   t h e   m o s t   r e c e n t l y   a d d e d   i t e m ,   s o   t h a t   i t   w i l l   s o r t   o n   t o p   i n   s t a c k s   w i t h   t h a t   o r d e r . 
 T h i s   s c r i p t   a s s u m e s   a n   i c o n   n a m e d   "   I c o n "   ( w i t h   t h e   s p a c e ,   s o   i t   s o r t s   f i r s t   i n   a l p h a b e t i c a l   s t a c k s ) . 
   
  
 l     ��������  ��  ��        i         I     �� ��
�� .facofgetnull���     alis  o      ���� 0 
thisfolder 
thisFolder��    I     �� ���� *0 reapplystackoverlay reapplyStackOverlay   ��  o    ���� 0 
thisfolder 
thisFolder��  ��        l     ��������  ��  ��        i        I     �� ��
�� .facoflosnull���     alis  o      ���� 0 
thisfolder 
thisFolder��    I     �� ���� *0 reapplystackoverlay reapplyStackOverlay   ��  o    ���� 0 
thisfolder 
thisFolder��  ��        l     ��������  ��  ��        i       !   I      �� "���� *0 reapplystackoverlay reapplyStackOverlay "  #�� # o      ���� 0 
thisfolder 
thisFolder��  ��   ! k     K $ $  % & % l     �� ' (��   ' . ( Something happened to reload the stack.    ( � ) ) P   S o m e t h i n g   h a p p e n e d   t o   r e l o a d   t h e   s t a c k . &  * + * r      , - , l     .���� . n      / 0 / 1    ��
�� 
psxp 0 l     1���� 1 c      2 3 2 o     ���� 0 
thisfolder 
thisFolder 3 m    ��
�� 
alis��  ��  ��  ��   - o      ���� 0 
folderpath 
folderPath +  4 5 4 l    6 7 8 6 r     9 : 9 m    	 ; ; � < < 
   I c o n : o      ���� 0 iconname iconName 7   again, with a space    8 � = = (   a g a i n ,   w i t h   a   s p a c e 5  > ? > r     @ A @ b     B C B o    ���� 0 
folderpath 
folderPath C o    ���� 0 iconname iconName A o      ���� 0 iconpath iconPath ?  D E D r     F G F b     H I H m     J J � K K 
 / t m p / I o    ���� 0 iconname iconName G o      ���� 0 tempiconpath tempIconPath E  L M L l   �� N O��   N   Unhide icon    O � P P    U n h i d e   i c o n M  Q R Q I   !�� S��
�� .sysoexecTEXT���     TEXT S b     T U T m     V V � W W " c h f l a g s   n o h i d d e n   U l    X���� X n     Y Z Y 1    ��
�� 
strq Z o    ���� 0 iconpath iconPath��  ��  ��   R  [ \ [ l  " "�� ] ^��   ] ? 9 Force stack to reload while updating "added at" for icon    ^ � _ _ r   F o r c e   s t a c k   t o   r e l o a d   w h i l e   u p d a t i n g   " a d d e d   a t "   f o r   i c o n \  ` a ` I  " 1�� b��
�� .sysoexecTEXT���     TEXT b b   " - c d c b   " ) e f e b   " ' g h g m   " # i i � j j  m v   h l  # & k���� k n   # & l m l 1   $ &��
�� 
strq m o   # $���� 0 iconpath iconPath��  ��   f m   ' ( n n � o o    d l  ) , p���� p n   ) , q r q 1   * ,��
�� 
strq r o   ) *���� 0 tempiconpath tempIconPath��  ��  ��   a  s t s I  2 A�� u��
�� .sysoexecTEXT���     TEXT u b   2 = v w v b   2 9 x y x b   2 7 z { z m   2 3 | | � } }  m v   { l  3 6 ~���� ~ n   3 6  �  1   4 6��
�� 
strq � o   3 4���� 0 tempiconpath tempIconPath��  ��   y m   7 8 � � � � �    w l  9 < ����� � n   9 < � � � 1   : <��
�� 
strq � o   9 :���� 0 iconpath iconPath��  ��  ��   t  � � � l  B B�� � ���   �  
 Hide icon    � � � �    H i d e   i c o n �  ��� � I  B K�� ���
�� .sysoexecTEXT���     TEXT � b   B G � � � m   B C � � � � �  c h f l a g s   h i d d e n   � l  C F ����� � n   C F � � � 1   D F��
�� 
strq � o   C D���� 0 iconpath iconPath��  ��  ��  ��     ��� � l     ��������  ��  ��  ��       �� � � � ���   � ������
�� .facofgetnull���     alis
�� .facoflosnull���     alis�� *0 reapplystackoverlay reapplyStackOverlay � �� ���� � ���
�� .facofgetnull���     alis�� 0 
thisfolder 
thisFolder��   � ���� 0 
thisfolder 
thisFolder � ���� *0 reapplystackoverlay reapplyStackOverlay�� *�k+   � �� ���� � ���
�� .facoflosnull���     alis�� 0 
thisfolder 
thisFolder��   � ���� 0 
thisfolder 
thisFolder � ���� *0 reapplystackoverlay reapplyStackOverlay�� *�k+   � �� !���� � ����� *0 reapplystackoverlay reapplyStackOverlay�� �� ���  �  ���� 0 
thisfolder 
thisFolder��   � ������������ 0 
thisfolder 
thisFolder�� 0 
folderpath 
folderPath�� 0 iconname iconName�� 0 iconpath iconPath�� 0 tempiconpath tempIconPath � ���� ; J V���� i n | � �
�� 
alis
�� 
psxp
�� 
strq
�� .sysoexecTEXT���     TEXT�� L��&�,E�O�E�O��%E�O�%E�O��,%j O��,%�%��,%j O��,%�%��,%j O��,%j ascr  ��ޭ