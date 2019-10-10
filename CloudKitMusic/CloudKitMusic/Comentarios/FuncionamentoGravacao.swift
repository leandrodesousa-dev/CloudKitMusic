//MARK: Como funciona o processo de gravação no IOS?

/*
 
 1- Precisamos informar ao ios onde ele vai gravar o audio
Na RecordWhistlerViewController, quando instanciamos o AVAudioRecorder, ele já faz isso para gente

2- antes de gravar precisamos informar:
A: formato
B: taxa bits
C: número do canal
D: qualidade
 
Minhas configurações:
A: AAC
B: 12000 Hz
C: 1, gravação simples
D: alta
 
3- defini o controlador de exibição como delegado da gravação, posso ver quando for pausado e se for concluída com sucesso ou não
 
4- a gravação não vai parar se o app entrar em segundo plano
 
*/
