FasdUAS 1.101.10   ��   ��    k             l     �� ��      Coda Light       	  l     �� 
��   
 7 1 By Henrik Nyh <http://henrik.nyh.se>, 2007-04-26    	     l     ������  ��        l     �� ��    G A An AppleScript to start working on a web development project by:         l     �� ��    ) #  * Opening the project in TextMate         l     �� ��    5 /  * Opening related URLs in the default browser         l     �� ��    8 2  * Opening the related favorite in Transmit (FTP)         l     �� ��    3 -  * Opening a related SSH session in Terminal         l     ������  ��        l     ��  ��     X R Inspired by Coda <http://www.panic.com/coda/>. Coda is a trademark of Panic, Inc.      ! " ! l     ������  ��   "  # $ # l     �� %��   %   --------------------------    $  & ' & l     �� (��   (   Configure here    '  ) * ) l     �� +��   +   --------------------------    *  , - , l     ������  ��   -  . / . l     �� 0��   0 4 . Full path to local file, TM project or folder    /  1 2 1 l     3�� 3 r      4 5 4 m      6 6 . (/Users/me/Sites/somesite/somesite.tmproj    5 o      ���� 0 localproject localProject��   2  7 8 7 l     ������  ��   8  9 : 9 l     �� ;��   ; 2 , These will be opened in the default browser    :  < = < l     �� >��   > "  (Set to {} to open nothing)    =  ? @ ? l   
 A�� A r    
 B C B J     D D  E F E m     G G # http://localhost/~me/somesite    F  H�� H m     I I ! http://example.com/somesite   ��   C o      ���� 0 urls URLs��   @  J K J l     ������  ��   K  L M L l     �� N��   N ) # The name of this Transmit favorite    M  O P O l     �� Q��   Q 5 / (Set to "" if you don't want to open Transmit)    P  R S R l    T�� T r     U V U m     W W  	Some site    V o      ���� $0 transmitfavorite transmitFavorite��   S  X Y X l     ������  ��   Y  Z [ Z l     �� \��   \   SSH server    [  ] ^ ] l     �� _��   _ 2 , (Set to "" if you don't want a SSH session)    ^  ` a ` l    b�� b r     c d c m     e e  example.com    d o      ���� 0 	sshserver 	sshServer��   a  f g f l     �� h��   h / ) SSH username (set to "" to use defaults)    g  i j i l    k�� k r     l m l m     n n       m o      ���� 0 sshuser sshUser��   j  o p o l     �� q��   q � � The SSH password must be entered manually; optionally set up DSA keys so you don't have to input it at all: see e.g. http://www.macosxhints.com/article.php?story=20011128174701140    p  r s r l     ������  ��   s  t u t l     �� v��   v   --------------------------    u  w x w l     �� y��   y   Configuration ends    x  z { z l     �� |��   |   --------------------------    {  } ~ } l     ������  ��   ~   �  l   � ��� � Z    � � ����� � >    � � � o    ���� $0 transmitfavorite transmitFavorite � m     � �       � O    � � � � k   ! � � �  � � � Z   ! ? � ����� � =  ! * � � � l  ! ( ��� � I  ! (�� ���
�� .corecnte****       **** � 2  ! $��
�� 
docu��  ��   � m   ( )����   � I  - ;���� �
�� .corecrel****      � null��   � �� � �
�� 
kocl � m   / 0��
�� 
docu � �� ���
�� 
insh �  ;   3 5��  ��  ��   �  ��� � O   @ � � � � k   G � � �  � � � r   G Q � � � l  G M ��� � 4   G M�� �
�� 
SeSn � m   K L���� ��   � o      ���� 0 thetab theTab �  � � � Z   R m � ����� � n   R ] � � � 1   X \��
�� 
isCn � 4   R X�� �
�� 
SeSn � m   V W����  � r   ` i � � � l  ` e ��� � I  ` e������
�� .docuaTabSeSn       obj ��  ��  ��   � o      ���� 0 thetab theTab��  ��   �  ��� � O   n � � � � Z   t � � ����� � H   t ~ � � l  t } ��� � I  t }���� �
�� .SeSncONFbool       obj ��   � �� ���
�� 
favN � o   x y���� $0 transmitfavorite transmitFavorite��  ��   � I  � ��� � �
�� .sysodlogaskr        TEXT � m   � � � � $ Could not connect to favorite!    � �� � �
�� 
btns � m   � � � �  
For shame!    � �� � �
�� 
dflt � m   � �����  � �� ���
�� 
disp � m   � ����� ��  ��  ��   � o   n q���� 0 thetab theTab��   � 4   @ D�� �
�� 
docu � m   B C���� ��   � m     � ��null     ߀��  @Transmit.app 0�P'g������1  �Q���; �����D��g���x����R��,�TrAn   alis    L  	BlackBook                  ��F�H+    @Transmit.app                                                    ��Q�K        ����  	                Applications    ��8�      �Q�+      @  #BlackBook:Applications:Transmit.app     T r a n s m i t . a p p   	 B l a c k B o o k  Applications/Transmit.app   / ��  ��  ��  ��   �  � � � l     ������  ��   �  � � � l     ������  ��   �  � � � l  � � ��� � Z   � � � ����� � >  � � � � � o   � ����� 0 	sshserver 	sshServer � m   � � � �       � O   � � � � � k   � � � �  � � � Z   � � � ����� � >  � � � � � o   � ����� 0 sshuser sshUser � m   � � � �       � r   � � � � � b   � � � � � o   � ����� 0 sshuser sshUser � m   � � � �  @    � o      ���� 0 sshuser sshUser��  ��   �  ��� � I  � ��� ���
�� .coredoscnull        TEXT � b   � � � � � b   � � � � � m   � � � � 
 ssh     � o   � ����� 0 sshuser sshUser � o   � ����� 0 	sshserver 	sshServer��  ��   � m   � � � ��null     ߀��  ATerminal.app P>�'g�������   lQ���; �����D��g���x����R��,�trmx   alis    b  	BlackBook                  ��F�H+    ATerminal.app                                                     
&��a�        ����  	                	Utilities     ��8�      ��S�      A  @  -BlackBook:Applications:Utilities:Terminal.app     T e r m i n a l . a p p   	 B l a c k B o o k  #Applications/Utilities/Terminal.app   / ��  ��  ��  ��   �  � � � l     ������  ��   �  � � � l  � � ��� � X   � � ��� � � l  � � � � � I  � ��� ���
�� .GURLGURLnull��� ��� TEXT � o   � ��� 0 anurl anURL��   �   in default browser   �� 0 anurl anURL � o   � ��~�~ 0 urls URLs��   �  � � � l     �}�|�}  �|   �  ��{ � l  � ��z � Z   � � ��y�x � >  � � � � � o   � ��w�w 0 localproject localProject � m   � � � �       � O   � � � � k   � �  � � � I �v ��u
�v .aevtodocnull  �    alis � c   � � � 4  �t �
�t 
psxf � o  �s�s 0 localproject localProject � m  �r
�r 
alis�u   �  ��q � I �p�o�n
�p .miscactvnull��� ��� null�o  �n  �q   � m   � � � ��null     ߀��  @TextMate.app�����@   x����T �    n���x�����͐    L���x���ɥ   TxMt   alis    L  	BlackBook                  ��F�H+    @TextMate.app                                                    ��&cG        ����  	                Applications    ��8�      �&U7      @  #BlackBook:Applications:TextMate.app     T e x t M a t e . a p p   	 B l a c k B o o k  Applications/TextMate.app   / ��  �y  �x  �z  �{       �m � �m   � �l
�l .aevtoappnull  �   � ****  �k�j�i�h
�k .aevtoappnull  �   � **** k      1  ?  R  `  i		  

  �  �  ��g�g  �j  �i   �f�f 0 anurl anURL . 6�e G I�d W�c e�b n�a � ��`�_�^�]�\�[�Z�Y�X�W�V�U ��T ��S�R�Q�P � � � � ��O�N�M � ��L�K�J�I�e 0 localproject localProject�d 0 urls URLs�c $0 transmitfavorite transmitFavorite�b 0 	sshserver 	sshServer�a 0 sshuser sshUser
�` 
docu
�_ .corecnte****       ****
�^ 
kocl
�] 
insh�\ 
�[ .corecrel****      � null
�Z 
SeSn�Y 0 thetab theTab
�X 
isCn
�W .docuaTabSeSn       obj 
�V 
favN
�U .SeSncONFbool       obj 
�T 
btns
�S 
dflt
�R 
disp�Q 
�P .sysodlogaskr        TEXT
�O .coredoscnull        TEXT
�N 
cobj
�M .GURLGURLnull��� ��� TEXT
�L 
psxf
�K 
alis
�J .aevtodocnull  �    alis
�I .miscactvnull��� ��� null�h�E�O��lvE�O�E�O�E�O�E�O�� �� *�-j j  *��a *6a  Y hO*�k/ X*a k/E` O*a k/a ,E *j E` Y hO_  **a �l  a a a a ka ka  Y hUUUY hO�a   +a ! !�a " �a #%E�Y hOa $�%�%j %UY hO �[�a &l kh  �j '[OY��O�a (  a ) *a *�/a +&j ,O*j -UY hascr  ��ޭ