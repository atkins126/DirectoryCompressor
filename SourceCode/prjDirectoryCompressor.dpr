program prjDirectoryCompressor;

{$APPTYPE CONSOLE}



// AbZipper denen nesne s�k��t�rma bile�eni olan
// Abbrevia bile�eninin bir uniti oluyor
// bu nesne sayesinde bir klas�r i�erisinde
// recursive bir �ekilde arama yaparak
// b�t�n alt klas�r ve dosyalar� stek bir zip dosyas� olarak
// s�k��t�rabilece�iz.
uses
  WinTypes,
  SysUtils, AbZipper;


// recursive olarak belirtilen klas�r� geziyor
// 2. parametre ise
// Abbrevia adl� s�k��t�rma bile�eninin bir nesnesi
// esas i�i o yap�yor zaten
procedure CompressFiles(directoryPath: string; compressor: TAbZipper);
var
//  compressor: TAbZipper;
  compressFileRec: TSearchRec;
  result: Integer;
begin
  try
    result := FindFirst(directoryPath + '\*.*', faDirectory, compressFileRec);
    while result = 0 do
    begin
      if (compressFileRec.Name <> '.') and (compressFileRec.Name <> '..') then
      begin
        CompressFiles(directoryPath + '\' + compressFileRec.Name, compressor);
      end;
      result := FindNext(compressFileRec);
    end;
    FindClose(compressFileRec);

    result := FindFirst(directoryPath + '\*.*', faAnyFile, compressFileRec);
    while result = 0 do
    begin
      compressor.AddFiles(directoryPath + '\' + compressFileRec.Name, faAnyFile);
      result := FindNext(compressFileRec);
    end;
    FindClose(compressFileRec);
  finally
  end;
end;



// program bir console application
// burada �nemli olan nokta ise
// e�er bu exe dosyas� �al��t�r�l�rken parametre alm��sa
// ald��� parametre dosyalar�n s�k��t�r�laca�� dizin oluyor ve
// ilgili metoda y�nlendiriyor
// parametre almazsa bulundu�u klas�rdeki dosyalar� s�k��t�rmaya
// yani ziplemeye ba�l�yor
// Abbrevia bile�enini burada bir kere olu�turuyoruz
// ve metoda g�nderip i�imiz bitince ortadan kald�r�yoruz
var
  directoryPath: string;
  zipper: TAbZipper;
begin
  if ParamCount = 1 then
  begin
    directoryPath := ParamStr(1);
    if DirectoryExists(directoryPath) then
    begin
      zipper := TAbZipper.Create(nil);
//      zipper.BaseDirectory := ExpandFileName(directoryPath + '\..');
      zipper.BaseDirectory := ExtractFilePath(directoryPath);
      zipper.FileName := ChangeFileExt(directoryPath, '.zip');
      CompressFiles(directoryPath, zipper);
      zipper.Save;
      zipper.CloseArchive;
      zipper.Free;
    end;
  end
  else
  begin
    directoryPath := GetCurrentDir;
    zipper := TAbZipper.Create(nil);
    zipper.BaseDirectory := ExtractFilePath(directoryPath);
    zipper.FileName := ChangeFileExt(directoryPath, '.zip');
    CompressFiles(directoryPath, zipper);
    zipper.Save;
    zipper.CloseArchive;
    zipper.Free;
  end;
end.

