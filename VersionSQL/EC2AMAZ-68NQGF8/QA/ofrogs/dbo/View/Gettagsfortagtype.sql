/****** Object:  View [dbo].[Gettagsfortagtype]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[Gettagsfortagtype]
as
select id,

REPLACE(REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(

  REPLACE(
  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(name,
   ' Company Ltd', ''),
 ' Company LLC', ''),
  ' Private Limited', ''),
  ' Private Ltd', ''),
  ', Incorporated', ''),
  ' Incorporated', ''),
  ' Corporation', ''),
  ' + Co LLP', ''),
  ' Co Ltd', ''),
  ' Pvt Ltd', ''),
  ' Pty Ltd', ''),
  ' (p) Ltd', ''),
  ', LLP', ''),
  ' LLP', ''),
  ', Inc.', ''),
  ' Inc.', ''),
  ' Corp.', ''),
  ', LLC', ''),
  ' Limited ', ''),
  ' Pvt. Ltd', ''),
  ' Ltd.', ''),
  ' Co.,ltd', ''),
  ' LLC', ''),
  ' Limited', ''),
  ' Co., Ltd', ''),
  ' Pte Ltd', ''),
  '"',''),
  ' Co, Ltd',''),
  ', Ltd',''),
  ' Ltd',''),
  '&','and'),
  '®',''),
  ', Inc',''),
  ' plc',''),
  ', L.P.',''),
  ', a GE company','') 
  name,tagtypeid from tag where --tagtypeid!='' 
  TagTypeId = 1
  and   id not in (select tagid from domainnameorg )
 
