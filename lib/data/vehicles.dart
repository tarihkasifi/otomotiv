// Araç Markaları ve Modelleri Veritabanı
// Türkiye pazarına özel genişletilmiş liste

class VehicleModel {
  final String name;
  final String years;

  const VehicleModel({required this.name, required this.years});
}

class VehicleBrand {
  final String name;
  final List<VehicleModel> models;

  const VehicleBrand({required this.name, required this.models});
}

final List<VehicleBrand> vehicleBrands = [
  // === TÜRK MARKALARI ===
  VehicleBrand(name: 'Togg', models: [
    VehicleModel(name: 'T10X', years: '2023-2026'),
    VehicleModel(name: 'T10F', years: '2025-2026'),
  ]),

  // === AVRUPA MARKALARI ===
  VehicleBrand(name: 'Audi', models: [
    VehicleModel(name: 'A1', years: '2010-2026'),
    VehicleModel(name: 'A3', years: '1996-2026'),
    VehicleModel(name: 'A4', years: '1994-2026'),
    VehicleModel(name: 'A5', years: '2007-2026'),
    VehicleModel(name: 'A6', years: '1994-2026'),
    VehicleModel(name: 'A7', years: '2010-2026'),
    VehicleModel(name: 'A8', years: '1994-2026'),
    VehicleModel(name: 'Q2', years: '2016-2026'),
    VehicleModel(name: 'Q3', years: '2011-2026'),
    VehicleModel(name: 'Q5', years: '2008-2026'),
    VehicleModel(name: 'Q7', years: '2005-2026'),
    VehicleModel(name: 'Q8', years: '2018-2026'),
    VehicleModel(name: 'TT', years: '1998-2026'),
    VehicleModel(name: 'e-tron', years: '2019-2026'),
  ]),

  VehicleBrand(name: 'BMW', models: [
    VehicleModel(name: '1 Serisi', years: '2004-2026'),
    VehicleModel(name: '2 Serisi', years: '2014-2026'),
    VehicleModel(name: '3 Serisi', years: '1975-2026'),
    VehicleModel(name: '4 Serisi', years: '2013-2026'),
    VehicleModel(name: '5 Serisi', years: '1972-2026'),
    VehicleModel(name: '6 Serisi', years: '2003-2026'),
    VehicleModel(name: '7 Serisi', years: '1977-2026'),
    VehicleModel(name: 'X1', years: '2009-2026'),
    VehicleModel(name: 'X2', years: '2018-2026'),
    VehicleModel(name: 'X3', years: '2003-2026'),
    VehicleModel(name: 'X4', years: '2014-2026'),
    VehicleModel(name: 'X5', years: '1999-2026'),
    VehicleModel(name: 'X6', years: '2008-2026'),
    VehicleModel(name: 'X7', years: '2019-2026'),
    VehicleModel(name: 'Z4', years: '2002-2026'),
    VehicleModel(name: 'i3', years: '2013-2026'),
    VehicleModel(name: 'i4', years: '2021-2026'),
    VehicleModel(name: 'iX', years: '2021-2026'),
  ]),

  VehicleBrand(name: 'Citroen', models: [
    VehicleModel(name: 'C1', years: '2005-2022'),
    VehicleModel(name: 'C3', years: '2002-2026'),
    VehicleModel(name: 'C3 Aircross', years: '2017-2026'),
    VehicleModel(name: 'C4', years: '2004-2026'),
    VehicleModel(name: 'C4 Cactus', years: '2014-2020'),
    VehicleModel(name: 'C5', years: '2001-2017'),
    VehicleModel(name: 'C5 Aircross', years: '2018-2026'),
    VehicleModel(name: 'Berlingo', years: '1996-2026'),
    VehicleModel(name: 'Nemo', years: '2007-2017'),
    VehicleModel(name: 'C-Elysee', years: '2012-2020'),
  ]),

  VehicleBrand(name: 'Dacia', models: [
    VehicleModel(name: 'Sandero', years: '2007-2026'),
    VehicleModel(name: 'Sandero Stepway', years: '2009-2026'),
    VehicleModel(name: 'Duster', years: '2010-2026'),
    VehicleModel(name: 'Logan', years: '2004-2026'),
    VehicleModel(name: 'Jogger', years: '2022-2026'),
    VehicleModel(name: 'Spring', years: '2021-2026'),
    VehicleModel(name: 'Lodgy', years: '2012-2022'),
    VehicleModel(name: 'Dokker', years: '2012-2021'),
  ]),

  VehicleBrand(name: 'Fiat', models: [
    VehicleModel(name: '500', years: '2007-2026'),
    VehicleModel(name: '500L', years: '2012-2026'),
    VehicleModel(name: '500X', years: '2014-2026'),
    VehicleModel(name: 'Egea Sedan', years: '2015-2026'),
    VehicleModel(name: 'Egea Hatchback', years: '2016-2026'),
    VehicleModel(name: 'Egea Cross', years: '2020-2026'),
    VehicleModel(name: 'Egea Station Wagon', years: '2016-2026'),
    VehicleModel(name: 'Panda', years: '1980-2026'),
    VehicleModel(name: 'Punto', years: '1993-2018'),
    VehicleModel(name: 'Linea', years: '2007-2018'),
    VehicleModel(name: 'Doblo', years: '2000-2026'),
    VehicleModel(name: 'Fiorino', years: '2007-2026'),
    VehicleModel(name: 'Ducato', years: '1981-2026'),
    VehicleModel(name: 'Tipo', years: '2015-2026'),
    VehicleModel(name: 'Bravo', years: '1995-2014'),
  ]),

  VehicleBrand(name: 'Ford', models: [
    VehicleModel(name: 'Fiesta', years: '1976-2024'),
    VehicleModel(name: 'Focus', years: '1998-2026'),
    VehicleModel(name: 'Focus Sedan', years: '1998-2026'),
    VehicleModel(name: 'Mondeo', years: '1993-2022'),
    VehicleModel(name: 'C-Max', years: '2003-2019'),
    VehicleModel(name: 'S-Max', years: '2006-2023'),
    VehicleModel(name: 'Galaxy', years: '1995-2023'),
    VehicleModel(name: 'EcoSport', years: '2012-2022'),
    VehicleModel(name: 'Kuga', years: '2008-2026'),
    VehicleModel(name: 'Puma', years: '2019-2026'),
    VehicleModel(name: 'Explorer', years: '2019-2026'),
    VehicleModel(name: 'Mustang', years: '1964-2026'),
    VehicleModel(name: 'Mustang Mach-E', years: '2020-2026'),
    VehicleModel(name: 'Ranger', years: '1998-2026'),
    VehicleModel(name: 'Transit', years: '1965-2026'),
    VehicleModel(name: 'Transit Connect', years: '2002-2026'),
    VehicleModel(name: 'Transit Courier', years: '2014-2026'),
    VehicleModel(name: 'Transit Custom', years: '2012-2026'),
    VehicleModel(name: 'Tourneo Connect', years: '2002-2026'),
    VehicleModel(name: 'Tourneo Courier', years: '2014-2026'),
    VehicleModel(name: 'Tourneo Custom', years: '2012-2026'),
  ]),

  VehicleBrand(name: 'Honda', models: [
    VehicleModel(name: 'Civic', years: '1972-2026'),
    VehicleModel(name: 'Civic Sedan', years: '1972-2026'),
    VehicleModel(name: 'Civic Hatchback', years: '1972-2026'),
    VehicleModel(name: 'Accord', years: '1976-2026'),
    VehicleModel(name: 'City', years: '1996-2026'),
    VehicleModel(name: 'Jazz', years: '2001-2026'),
    VehicleModel(name: 'CR-V', years: '1995-2026'),
    VehicleModel(name: 'HR-V', years: '1998-2026'),
    VehicleModel(name: 'ZR-V', years: '2023-2026'),
    VehicleModel(name: 'e:Ny1', years: '2023-2026'),
  ]),

  VehicleBrand(name: 'Hyundai', models: [
    VehicleModel(name: 'i10', years: '2007-2026'),
    VehicleModel(name: 'i20', years: '2008-2026'),
    VehicleModel(name: 'i30', years: '2007-2026'),
    VehicleModel(name: 'Accent', years: '1994-2026'),
    VehicleModel(name: 'Elantra', years: '1990-2026'),
    VehicleModel(name: 'Tucson', years: '2004-2026'),
    VehicleModel(name: 'Kona', years: '2017-2026'),
    VehicleModel(name: 'Bayon', years: '2021-2026'),
    VehicleModel(name: 'Santa Fe', years: '2000-2026'),
    VehicleModel(name: 'ix35', years: '2009-2015'),
    VehicleModel(name: 'Getz', years: '2002-2011'),
    VehicleModel(name: 'Ioniq 5', years: '2021-2026'),
    VehicleModel(name: 'Ioniq 6', years: '2022-2026'),
    VehicleModel(name: 'Kona Electric', years: '2018-2026'),
  ]),

  VehicleBrand(name: 'Kia', models: [
    VehicleModel(name: 'Picanto', years: '2004-2026'),
    VehicleModel(name: 'Rio', years: '1999-2026'),
    VehicleModel(name: 'Ceed', years: '2006-2026'),
    VehicleModel(name: 'Proceed', years: '2018-2026'),
    VehicleModel(name: 'XCeed', years: '2019-2026'),
    VehicleModel(name: 'Cerato', years: '2003-2026'),
    VehicleModel(name: 'Optima', years: '2010-2020'),
    VehicleModel(name: 'Stinger', years: '2017-2026'),
    VehicleModel(name: 'Sportage', years: '1993-2026'),
    VehicleModel(name: 'Sorento', years: '2002-2026'),
    VehicleModel(name: 'Stonic', years: '2017-2026'),
    VehicleModel(name: 'Niro', years: '2016-2026'),
    VehicleModel(name: 'EV6', years: '2021-2026'),
    VehicleModel(name: 'EV9', years: '2023-2026'),
  ]),

  VehicleBrand(name: 'Mercedes-Benz', models: [
    VehicleModel(name: 'A Serisi', years: '1997-2026'),
    VehicleModel(name: 'B Serisi', years: '2005-2026'),
    VehicleModel(name: 'C Serisi', years: '1993-2026'),
    VehicleModel(name: 'CLA', years: '2013-2026'),
    VehicleModel(name: 'CLS', years: '2004-2026'),
    VehicleModel(name: 'E Serisi', years: '1953-2026'),
    VehicleModel(name: 'S Serisi', years: '1972-2026'),
    VehicleModel(name: 'GLA', years: '2013-2026'),
    VehicleModel(name: 'GLB', years: '2019-2026'),
    VehicleModel(name: 'GLC', years: '2015-2026'),
    VehicleModel(name: 'GLE', years: '2015-2026'),
    VehicleModel(name: 'GLS', years: '2015-2026'),
    VehicleModel(name: 'Vito', years: '1996-2026'),
    VehicleModel(name: 'Sprinter', years: '1995-2026'),
    VehicleModel(name: 'EQA', years: '2021-2026'),
    VehicleModel(name: 'EQB', years: '2021-2026'),
    VehicleModel(name: 'EQC', years: '2019-2026'),
    VehicleModel(name: 'EQE', years: '2022-2026'),
    VehicleModel(name: 'EQS', years: '2021-2026'),
  ]),

  VehicleBrand(name: 'Mini', models: [
    VehicleModel(name: 'Cooper', years: '2001-2026'),
    VehicleModel(name: 'Cooper S', years: '2001-2026'),
    VehicleModel(name: 'Countryman', years: '2010-2026'),
    VehicleModel(name: 'Clubman', years: '2007-2026'),
    VehicleModel(name: 'Cabrio', years: '2004-2026'),
  ]),

  VehicleBrand(name: 'Opel', models: [
    VehicleModel(name: 'Corsa', years: '1982-2026'),
    VehicleModel(name: 'Astra', years: '1991-2026'),
    VehicleModel(name: 'Astra Sedan', years: '1998-2022'),
    VehicleModel(name: 'Insignia', years: '2008-2022'),
    VehicleModel(name: 'Mokka', years: '2012-2026'),
    VehicleModel(name: 'Crossland', years: '2017-2026'),
    VehicleModel(name: 'Grandland', years: '2017-2026'),
    VehicleModel(name: 'Combo', years: '1993-2026'),
    VehicleModel(name: 'Vivaro', years: '2001-2026'),
    VehicleModel(name: 'Zafira', years: '1999-2019'),
    VehicleModel(name: 'Meriva', years: '2003-2017'),
  ]),

  VehicleBrand(name: 'Peugeot', models: [
    VehicleModel(name: '108', years: '2014-2022'),
    VehicleModel(name: '208', years: '2012-2026'),
    VehicleModel(name: '301', years: '2012-2022'),
    VehicleModel(name: '308', years: '2007-2026'),
    VehicleModel(name: '408', years: '2022-2026'),
    VehicleModel(name: '508', years: '2010-2026'),
    VehicleModel(name: '2008', years: '2013-2026'),
    VehicleModel(name: '3008', years: '2008-2026'),
    VehicleModel(name: '5008', years: '2009-2026'),
    VehicleModel(name: 'Partner', years: '1996-2026'),
    VehicleModel(name: 'Rifter', years: '2018-2026'),
    VehicleModel(name: 'Traveller', years: '2016-2026'),
    VehicleModel(name: 'Expert', years: '1995-2026'),
    VehicleModel(name: 'Boxer', years: '1994-2026'),
    VehicleModel(name: 'e-208', years: '2019-2026'),
    VehicleModel(name: 'e-2008', years: '2020-2026'),
  ]),

  VehicleBrand(name: 'Renault', models: [
    VehicleModel(name: 'Clio', years: '1990-2026'),
    VehicleModel(name: 'Megane', years: '1995-2026'),
    VehicleModel(name: 'Megane Sedan', years: '2003-2022'),
    VehicleModel(name: 'Taliant', years: '2021-2026'),
    VehicleModel(name: 'Symbol', years: '1999-2013'),
    VehicleModel(name: 'Fluence', years: '2009-2017'),
    VehicleModel(name: 'Latitude', years: '2010-2015'),
    VehicleModel(name: 'Captur', years: '2013-2026'),
    VehicleModel(name: 'Kadjar', years: '2015-2022'),
    VehicleModel(name: 'Koleos', years: '2007-2026'),
    VehicleModel(name: 'Austral', years: '2022-2026'),
    VehicleModel(name: 'Scenic', years: '1996-2026'),
    VehicleModel(name: 'Kangoo', years: '1997-2026'),
    VehicleModel(name: 'Trafic', years: '1980-2026'),
    VehicleModel(name: 'Master', years: '1980-2026'),
    VehicleModel(name: 'Zoe', years: '2012-2026'),
    VehicleModel(name: 'Megane E-Tech', years: '2022-2026'),
  ]),

  VehicleBrand(name: 'Seat', models: [
    VehicleModel(name: 'Ibiza', years: '1984-2026'),
    VehicleModel(name: 'Leon', years: '1999-2026'),
    VehicleModel(name: 'Arona', years: '2017-2026'),
    VehicleModel(name: 'Ateca', years: '2016-2026'),
    VehicleModel(name: 'Tarraco', years: '2018-2026'),
    VehicleModel(name: 'Toledo', years: '1991-2019'),
    VehicleModel(name: 'Alhambra', years: '1996-2020'),
  ]),

  VehicleBrand(name: 'Skoda', models: [
    VehicleModel(name: 'Fabia', years: '1999-2026'),
    VehicleModel(name: 'Scala', years: '2019-2026'),
    VehicleModel(name: 'Octavia', years: '1996-2026'),
    VehicleModel(name: 'Superb', years: '2001-2026'),
    VehicleModel(name: 'Kamiq', years: '2019-2026'),
    VehicleModel(name: 'Karoq', years: '2017-2026'),
    VehicleModel(name: 'Kodiaq', years: '2016-2026'),
    VehicleModel(name: 'Enyaq', years: '2021-2026'),
    VehicleModel(name: 'Rapid', years: '2012-2019'),
    VehicleModel(name: 'Yeti', years: '2009-2017'),
  ]),

  VehicleBrand(name: 'Volkswagen', models: [
    VehicleModel(name: 'Polo', years: '1975-2026'),
    VehicleModel(name: 'Golf', years: '1974-2026'),
    VehicleModel(name: 'Golf Variant', years: '1993-2026'),
    VehicleModel(name: 'Jetta', years: '1979-2026'),
    VehicleModel(name: 'Passat', years: '1973-2026'),
    VehicleModel(name: 'Passat Variant', years: '1973-2026'),
    VehicleModel(name: 'Arteon', years: '2017-2026'),
    VehicleModel(name: 'T-Cross', years: '2018-2026'),
    VehicleModel(name: 'T-Roc', years: '2017-2026'),
    VehicleModel(name: 'Tiguan', years: '2007-2026'),
    VehicleModel(name: 'Touareg', years: '2002-2026'),
    VehicleModel(name: 'Touran', years: '2003-2026'),
    VehicleModel(name: 'Sharan', years: '1995-2022'),
    VehicleModel(name: 'Caddy', years: '1982-2026'),
    VehicleModel(name: 'Transporter', years: '1950-2026'),
    VehicleModel(name: 'Caravelle', years: '1990-2026'),
    VehicleModel(name: 'Crafter', years: '2006-2026'),
    VehicleModel(name: 'Amarok', years: '2010-2026'),
    VehicleModel(name: 'ID.3', years: '2020-2026'),
    VehicleModel(name: 'ID.4', years: '2020-2026'),
    VehicleModel(name: 'ID.5', years: '2021-2026'),
    VehicleModel(name: 'ID.7', years: '2023-2026'),
  ]),

  VehicleBrand(name: 'Volvo', models: [
    VehicleModel(name: 'S60', years: '2000-2026'),
    VehicleModel(name: 'S90', years: '2016-2026'),
    VehicleModel(name: 'V60', years: '2010-2026'),
    VehicleModel(name: 'V90', years: '2016-2026'),
    VehicleModel(name: 'XC40', years: '2017-2026'),
    VehicleModel(name: 'XC60', years: '2008-2026'),
    VehicleModel(name: 'XC90', years: '2002-2026'),
    VehicleModel(name: 'C40 Recharge', years: '2021-2026'),
    VehicleModel(name: 'EX30', years: '2024-2026'),
    VehicleModel(name: 'EX90', years: '2024-2026'),
  ]),

  // === JAPON MARKALARI ===
  VehicleBrand(name: 'Mazda', models: [
    VehicleModel(name: 'Mazda2', years: '2003-2026'),
    VehicleModel(name: 'Mazda3', years: '2003-2026'),
    VehicleModel(name: 'Mazda6', years: '2002-2026'),
    VehicleModel(name: 'CX-3', years: '2015-2026'),
    VehicleModel(name: 'CX-30', years: '2019-2026'),
    VehicleModel(name: 'CX-5', years: '2012-2026'),
    VehicleModel(name: 'CX-60', years: '2022-2026'),
    VehicleModel(name: 'MX-5', years: '1989-2026'),
    VehicleModel(name: 'MX-30', years: '2020-2026'),
  ]),

  VehicleBrand(name: 'Mitsubishi', models: [
    VehicleModel(name: 'ASX', years: '2010-2026'),
    VehicleModel(name: 'Eclipse Cross', years: '2017-2026'),
    VehicleModel(name: 'Outlander', years: '2001-2026'),
    VehicleModel(name: 'L200', years: '1978-2026'),
    VehicleModel(name: 'Pajero', years: '1981-2021'),
    VehicleModel(name: 'Space Star', years: '2012-2026'),
    VehicleModel(name: 'Colt', years: '1978-2012'),
    VehicleModel(name: 'Lancer', years: '1973-2017'),
  ]),

  VehicleBrand(name: 'Nissan', models: [
    VehicleModel(name: 'Micra', years: '1982-2026'),
    VehicleModel(name: 'Note', years: '2004-2026'),
    VehicleModel(name: 'Juke', years: '2010-2026'),
    VehicleModel(name: 'Qashqai', years: '2006-2026'),
    VehicleModel(name: 'X-Trail', years: '2000-2026'),
    VehicleModel(name: 'Navara', years: '1985-2026'),
    VehicleModel(name: 'Leaf', years: '2010-2026'),
    VehicleModel(name: 'Ariya', years: '2022-2026'),
    VehicleModel(name: '370Z', years: '2009-2020'),
    VehicleModel(name: 'GT-R', years: '2007-2026'),
  ]),

  VehicleBrand(name: 'Suzuki', models: [
    VehicleModel(name: 'Swift', years: '1983-2026'),
    VehicleModel(name: 'Baleno', years: '1995-2026'),
    VehicleModel(name: 'Ignis', years: '2000-2026'),
    VehicleModel(name: 'Vitara', years: '1988-2026'),
    VehicleModel(name: 'S-Cross', years: '2013-2026'),
    VehicleModel(name: 'Jimny', years: '1970-2026'),
    VehicleModel(name: 'SX4', years: '2006-2014'),
    VehicleModel(name: 'Across', years: '2020-2026'),
    VehicleModel(name: 'Swace', years: '2020-2026'),
  ]),

  VehicleBrand(name: 'Toyota', models: [
    VehicleModel(name: 'Yaris', years: '1999-2026'),
    VehicleModel(name: 'Yaris Cross', years: '2020-2026'),
    VehicleModel(name: 'Corolla', years: '1966-2026'),
    VehicleModel(name: 'Corolla Sedan', years: '1966-2026'),
    VehicleModel(name: 'Corolla Hatchback', years: '2018-2026'),
    VehicleModel(name: 'Corolla Cross', years: '2021-2026'),
    VehicleModel(name: 'Camry', years: '1982-2026'),
    VehicleModel(name: 'C-HR', years: '2016-2026'),
    VehicleModel(name: 'RAV4', years: '1994-2026'),
    VehicleModel(name: 'Highlander', years: '2000-2026'),
    VehicleModel(name: 'Land Cruiser', years: '1951-2026'),
    VehicleModel(name: 'Land Cruiser Prado', years: '1984-2026'),
    VehicleModel(name: 'Hilux', years: '1968-2026'),
    VehicleModel(name: 'Supra', years: '1978-2026'),
    VehicleModel(name: 'GR86', years: '2021-2026'),
    VehicleModel(name: 'Proace', years: '2013-2026'),
    VehicleModel(name: 'Proace City', years: '2019-2026'),
    VehicleModel(name: 'bZ4X', years: '2022-2026'),
    VehicleModel(name: 'Prius', years: '1997-2026'),
    VehicleModel(name: 'Auris', years: '2006-2018'),
    VehicleModel(name: 'Avensis', years: '1997-2018'),
    VehicleModel(name: 'Verso', years: '2009-2018'),
  ]),

  VehicleBrand(name: 'Subaru', models: [
    VehicleModel(name: 'Impreza', years: '1992-2026'),
    VehicleModel(name: 'XV', years: '2012-2026'),
    VehicleModel(name: 'Forester', years: '1997-2026'),
    VehicleModel(name: 'Outback', years: '1994-2026'),
    VehicleModel(name: 'Legacy', years: '1989-2026'),
    VehicleModel(name: 'BRZ', years: '2012-2026'),
    VehicleModel(name: 'Solterra', years: '2022-2026'),
  ]),

  // === AMERİKAN MARKALARI ===
  VehicleBrand(name: 'Chevrolet', models: [
    VehicleModel(name: 'Aveo', years: '2002-2018'),
    VehicleModel(name: 'Cruze', years: '2008-2019'),
    VehicleModel(name: 'Spark', years: '1998-2022'),
    VehicleModel(name: 'Trax', years: '2013-2026'),
    VehicleModel(name: 'Captiva', years: '2006-2026'),
    VehicleModel(name: 'Camaro', years: '1966-2026'),
    VehicleModel(name: 'Corvette', years: '1953-2026'),
  ]),

  VehicleBrand(name: 'Jeep', models: [
    VehicleModel(name: 'Renegade', years: '2014-2026'),
    VehicleModel(name: 'Compass', years: '2006-2026'),
    VehicleModel(name: 'Cherokee', years: '1974-2026'),
    VehicleModel(name: 'Grand Cherokee', years: '1992-2026'),
    VehicleModel(name: 'Wrangler', years: '1986-2026'),
    VehicleModel(name: 'Gladiator', years: '2019-2026'),
    VehicleModel(name: 'Avenger', years: '2022-2026'),
  ]),

  VehicleBrand(name: 'Tesla', models: [
    VehicleModel(name: 'Model 3', years: '2017-2026'),
    VehicleModel(name: 'Model Y', years: '2020-2026'),
    VehicleModel(name: 'Model S', years: '2012-2026'),
    VehicleModel(name: 'Model X', years: '2015-2026'),
    VehicleModel(name: 'Cybertruck', years: '2023-2026'),
  ]),

  // === KORE MARKALARI ===
  VehicleBrand(name: 'SsangYong', models: [
    VehicleModel(name: 'Tivoli', years: '2015-2026'),
    VehicleModel(name: 'Korando', years: '1983-2026'),
    VehicleModel(name: 'Rexton', years: '2001-2026'),
    VehicleModel(name: 'Musso', years: '1993-2026'),
    VehicleModel(name: 'Torres', years: '2022-2026'),
  ]),

  // === ÇİN MARKALARI ===
  VehicleBrand(name: 'BYD', models: [
    VehicleModel(name: 'Atto 3', years: '2022-2026'),
    VehicleModel(name: 'Han', years: '2020-2026'),
    VehicleModel(name: 'Tang', years: '2018-2026'),
    VehicleModel(name: 'Seal', years: '2022-2026'),
    VehicleModel(name: 'Dolphin', years: '2021-2026'),
  ]),

  VehicleBrand(name: 'MG', models: [
    VehicleModel(name: 'ZS', years: '2017-2026'),
    VehicleModel(name: 'ZS EV', years: '2019-2026'),
    VehicleModel(name: 'HS', years: '2018-2026'),
    VehicleModel(name: 'Marvel R', years: '2021-2026'),
    VehicleModel(name: 'MG4', years: '2022-2026'),
    VehicleModel(name: 'MG5', years: '2022-2026'),
  ]),

  VehicleBrand(name: 'Chery', models: [
    VehicleModel(name: 'Tiggo 4 Pro', years: '2022-2026'),
    VehicleModel(name: 'Tiggo 7 Pro', years: '2022-2026'),
    VehicleModel(name: 'Tiggo 8 Pro', years: '2022-2026'),
    VehicleModel(name: 'Arrizo 6', years: '2022-2026'),
  ]),

  // === DİĞER ===
  VehicleBrand(name: 'Alfa Romeo', models: [
    VehicleModel(name: 'Giulietta', years: '2010-2022'),
    VehicleModel(name: 'Giulia', years: '2015-2026'),
    VehicleModel(name: 'Stelvio', years: '2016-2026'),
    VehicleModel(name: 'Tonale', years: '2022-2026'),
    VehicleModel(name: 'MiTo', years: '2008-2018'),
  ]),

  VehicleBrand(name: 'Cupra', models: [
    VehicleModel(name: 'Born', years: '2021-2026'),
    VehicleModel(name: 'Formentor', years: '2020-2026'),
    VehicleModel(name: 'Leon', years: '2020-2026'),
    VehicleModel(name: 'Ateca', years: '2020-2026'),
    VehicleModel(name: 'Tavascan', years: '2024-2026'),
  ]),

  VehicleBrand(name: 'DS', models: [
    VehicleModel(name: 'DS 3', years: '2015-2026'),
    VehicleModel(name: 'DS 4', years: '2021-2026'),
    VehicleModel(name: 'DS 7', years: '2017-2026'),
    VehicleModel(name: 'DS 9', years: '2020-2026'),
  ]),

  VehicleBrand(name: 'Jaguar', models: [
    VehicleModel(name: 'XE', years: '2015-2026'),
    VehicleModel(name: 'XF', years: '2007-2026'),
    VehicleModel(name: 'XJ', years: '1968-2019'),
    VehicleModel(name: 'E-Pace', years: '2017-2026'),
    VehicleModel(name: 'F-Pace', years: '2016-2026'),
    VehicleModel(name: 'I-Pace', years: '2018-2026'),
  ]),

  VehicleBrand(name: 'Land Rover', models: [
    VehicleModel(name: 'Defender', years: '1983-2026'),
    VehicleModel(name: 'Discovery', years: '1989-2026'),
    VehicleModel(name: 'Discovery Sport', years: '2014-2026'),
    VehicleModel(name: 'Range Rover', years: '1970-2026'),
    VehicleModel(name: 'Range Rover Sport', years: '2005-2026'),
    VehicleModel(name: 'Range Rover Evoque', years: '2011-2026'),
    VehicleModel(name: 'Range Rover Velar', years: '2017-2026'),
  ]),

  VehicleBrand(name: 'Lexus', models: [
    VehicleModel(name: 'CT', years: '2010-2022'),
    VehicleModel(name: 'ES', years: '1989-2026'),
    VehicleModel(name: 'IS', years: '1999-2026'),
    VehicleModel(name: 'NX', years: '2014-2026'),
    VehicleModel(name: 'RX', years: '1998-2026'),
    VehicleModel(name: 'UX', years: '2018-2026'),
    VehicleModel(name: 'LBX', years: '2023-2026'),
    VehicleModel(name: 'RZ', years: '2022-2026'),
  ]),

  VehicleBrand(name: 'Polestar', models: [
    VehicleModel(name: 'Polestar 2', years: '2020-2026'),
    VehicleModel(name: 'Polestar 3', years: '2023-2026'),
    VehicleModel(name: 'Polestar 4', years: '2024-2026'),
  ]),

  VehicleBrand(name: 'Porsche', models: [
    VehicleModel(name: '911', years: '1964-2026'),
    VehicleModel(name: '718 Cayman', years: '2016-2026'),
    VehicleModel(name: '718 Boxster', years: '2016-2026'),
    VehicleModel(name: 'Panamera', years: '2009-2026'),
    VehicleModel(name: 'Cayenne', years: '2002-2026'),
    VehicleModel(name: 'Macan', years: '2014-2026'),
    VehicleModel(name: 'Taycan', years: '2019-2026'),
  ]),

  // === LÜKS MARKALAR ===
  VehicleBrand(name: 'Aston Martin', models: [
    VehicleModel(name: 'DB11', years: '2016-2026'),
    VehicleModel(name: 'DB12', years: '2023-2026'),
    VehicleModel(name: 'Vantage', years: '2005-2026'),
    VehicleModel(name: 'DBS Superleggera', years: '2018-2026'),
    VehicleModel(name: 'DBX', years: '2020-2026'),
    VehicleModel(name: 'DBX707', years: '2022-2026'),
    VehicleModel(name: 'Rapide', years: '2010-2020'),
    VehicleModel(name: 'Valkyrie', years: '2021-2026'),
  ]),

  VehicleBrand(name: 'Bentley', models: [
    VehicleModel(name: 'Continental GT', years: '2003-2026'),
    VehicleModel(name: 'Continental GTC', years: '2006-2026'),
    VehicleModel(name: 'Flying Spur', years: '2005-2026'),
    VehicleModel(name: 'Bentayga', years: '2015-2026'),
    VehicleModel(name: 'Mulsanne', years: '2010-2020'),
  ]),

  VehicleBrand(name: 'Ferrari', models: [
    VehicleModel(name: '296 GTB', years: '2021-2026'),
    VehicleModel(name: '296 GTS', years: '2022-2026'),
    VehicleModel(name: 'Roma', years: '2019-2026'),
    VehicleModel(name: 'Roma Spider', years: '2023-2026'),
    VehicleModel(name: 'Portofino M', years: '2020-2026'),
    VehicleModel(name: 'SF90 Stradale', years: '2019-2026'),
    VehicleModel(name: 'SF90 Spider', years: '2020-2026'),
    VehicleModel(name: '812 Superfast', years: '2017-2026'),
    VehicleModel(name: '812 GTS', years: '2019-2026'),
    VehicleModel(name: 'F8 Tributo', years: '2019-2026'),
    VehicleModel(name: 'F8 Spider', years: '2019-2026'),
    VehicleModel(name: 'Purosangue', years: '2022-2026'),
    VehicleModel(name: '488 GTB', years: '2015-2020'),
    VehicleModel(name: '458 Italia', years: '2009-2015'),
    VehicleModel(name: 'California', years: '2008-2017'),
  ]),

  VehicleBrand(name: 'Lamborghini', models: [
    VehicleModel(name: 'Huracán', years: '2014-2026'),
    VehicleModel(name: 'Huracán EVO', years: '2019-2026'),
    VehicleModel(name: 'Huracán Tecnica', years: '2022-2026'),
    VehicleModel(name: 'Huracán Sterrato', years: '2023-2026'),
    VehicleModel(name: 'Urus', years: '2018-2026'),
    VehicleModel(name: 'Urus S', years: '2022-2026'),
    VehicleModel(name: 'Urus Performante', years: '2022-2026'),
    VehicleModel(name: 'Revuelto', years: '2023-2026'),
    VehicleModel(name: 'Aventador', years: '2011-2022'),
    VehicleModel(name: 'Gallardo', years: '2003-2013'),
  ]),

  VehicleBrand(name: 'Maserati', models: [
    VehicleModel(name: 'Ghibli', years: '2013-2026'),
    VehicleModel(name: 'Quattroporte', years: '1963-2026'),
    VehicleModel(name: 'Levante', years: '2016-2026'),
    VehicleModel(name: 'GranTurismo', years: '2007-2026'),
    VehicleModel(name: 'GranCabrio', years: '2010-2026'),
    VehicleModel(name: 'MC20', years: '2020-2026'),
    VehicleModel(name: 'MC20 Cielo', years: '2022-2026'),
    VehicleModel(name: 'Grecale', years: '2022-2026'),
  ]),

  VehicleBrand(name: 'Rolls-Royce', models: [
    VehicleModel(name: 'Phantom', years: '2003-2026'),
    VehicleModel(name: 'Ghost', years: '2009-2026'),
    VehicleModel(name: 'Wraith', years: '2013-2026'),
    VehicleModel(name: 'Dawn', years: '2015-2026'),
    VehicleModel(name: 'Cullinan', years: '2018-2026'),
    VehicleModel(name: 'Spectre', years: '2023-2026'),
  ]),

  VehicleBrand(name: 'McLaren', models: [
    VehicleModel(name: '720S', years: '2017-2026'),
    VehicleModel(name: '720S Spider', years: '2019-2026'),
    VehicleModel(name: '765LT', years: '2020-2026'),
    VehicleModel(name: 'Artura', years: '2021-2026'),
    VehicleModel(name: 'GT', years: '2019-2026'),
    VehicleModel(name: '570S', years: '2015-2021'),
    VehicleModel(name: '600LT', years: '2018-2021'),
    VehicleModel(name: 'Senna', years: '2018-2020'),
  ]),

  // === KORE LÜKS ===
  VehicleBrand(name: 'Genesis', models: [
    VehicleModel(name: 'G70', years: '2017-2026'),
    VehicleModel(name: 'G80', years: '2016-2026'),
    VehicleModel(name: 'G90', years: '2016-2026'),
    VehicleModel(name: 'GV60', years: '2021-2026'),
    VehicleModel(name: 'GV70', years: '2020-2026'),
    VehicleModel(name: 'GV80', years: '2020-2026'),
    VehicleModel(name: 'Electrified G80', years: '2021-2026'),
    VehicleModel(name: 'Electrified GV70', years: '2022-2026'),
  ]),

  VehicleBrand(name: 'Infiniti', models: [
    VehicleModel(name: 'Q50', years: '2013-2026'),
    VehicleModel(name: 'Q60', years: '2016-2026'),
    VehicleModel(name: 'Q70', years: '2014-2019'),
    VehicleModel(name: 'QX50', years: '2018-2026'),
    VehicleModel(name: 'QX55', years: '2021-2026'),
    VehicleModel(name: 'QX60', years: '2012-2026'),
    VehicleModel(name: 'QX80', years: '2010-2026'),
  ]),

  // === ÇİN MARKALARI (EK) ===
  VehicleBrand(name: 'Great Wall', models: [
    VehicleModel(name: 'Haval H6', years: '2011-2026'),
    VehicleModel(name: 'Haval Jolion', years: '2020-2026'),
    VehicleModel(name: 'Haval H9', years: '2014-2026'),
    VehicleModel(name: 'Haval Dargo', years: '2021-2026'),
    VehicleModel(name: 'Ora Good Cat', years: '2020-2026'),
    VehicleModel(name: 'Ora Funky Cat', years: '2022-2026'),
    VehicleModel(name: 'Wey Coffee 01', years: '2021-2026'),
    VehicleModel(name: 'Wey Coffee 02', years: '2022-2026'),
    VehicleModel(name: 'Tank 300', years: '2020-2026'),
    VehicleModel(name: 'Tank 500', years: '2021-2026'),
    VehicleModel(name: 'Poer', years: '2019-2026'),
  ]),

  VehicleBrand(name: 'Geely', models: [
    VehicleModel(name: 'Coolray', years: '2018-2026'),
    VehicleModel(name: 'Azkarra', years: '2019-2026'),
    VehicleModel(name: 'Okavango', years: '2020-2026'),
    VehicleModel(name: 'Emgrand', years: '2009-2026'),
    VehicleModel(name: 'Monjaro', years: '2022-2026'),
    VehicleModel(name: 'Atlas Pro', years: '2021-2026'),
    VehicleModel(name: 'Tugella', years: '2020-2026'),
    VehicleModel(name: 'Geometry C', years: '2020-2026'),
  ]),

  VehicleBrand(name: 'Lynk & Co', models: [
    VehicleModel(name: '01', years: '2017-2026'),
    VehicleModel(name: '02', years: '2018-2026'),
    VehicleModel(name: '03', years: '2018-2026'),
    VehicleModel(name: '05', years: '2020-2026'),
    VehicleModel(name: '06', years: '2020-2026'),
    VehicleModel(name: '09', years: '2021-2026'),
  ]),

  VehicleBrand(name: 'NIO', models: [
    VehicleModel(name: 'ES6', years: '2019-2026'),
    VehicleModel(name: 'ES7', years: '2022-2026'),
    VehicleModel(name: 'ES8', years: '2018-2026'),
    VehicleModel(name: 'EC6', years: '2020-2026'),
    VehicleModel(name: 'EC7', years: '2022-2026'),
    VehicleModel(name: 'ET5', years: '2022-2026'),
    VehicleModel(name: 'ET7', years: '2021-2026'),
    VehicleModel(name: 'EL6', years: '2023-2026'),
    VehicleModel(name: 'EL7', years: '2023-2026'),
  ]),

  VehicleBrand(name: 'Xpeng', models: [
    VehicleModel(name: 'P7', years: '2020-2026'),
    VehicleModel(name: 'P5', years: '2021-2026'),
    VehicleModel(name: 'G3', years: '2018-2026'),
    VehicleModel(name: 'G6', years: '2023-2026'),
    VehicleModel(name: 'G9', years: '2022-2026'),
    VehicleModel(name: 'X9', years: '2024-2026'),
  ]),

  VehicleBrand(name: 'Zeekr', models: [
    VehicleModel(name: '001', years: '2021-2026'),
    VehicleModel(name: '007', years: '2024-2026'),
    VehicleModel(name: '009', years: '2022-2026'),
    VehicleModel(name: 'X', years: '2024-2026'),
  ]),

  VehicleBrand(name: 'Li Auto', models: [
    VehicleModel(name: 'L6', years: '2024-2026'),
    VehicleModel(name: 'L7', years: '2023-2026'),
    VehicleModel(name: 'L8', years: '2022-2026'),
    VehicleModel(name: 'L9', years: '2022-2026'),
    VehicleModel(name: 'Mega', years: '2024-2026'),
    VehicleModel(name: 'One', years: '2019-2022'),
  ]),

  // === TİCARİ ARAÇLAR ===
  VehicleBrand(name: 'Isuzu', models: [
    VehicleModel(name: 'D-Max', years: '2002-2026'),
    VehicleModel(name: 'MU-X', years: '2013-2026'),
    VehicleModel(name: 'D-Max Arctic Trucks AT35', years: '2016-2026'),
    VehicleModel(name: 'N-Series', years: '1980-2026'),
    VehicleModel(name: 'F-Series', years: '1980-2026'),
  ]),

  VehicleBrand(name: 'Iveco', models: [
    VehicleModel(name: 'Daily', years: '1978-2026'),
    VehicleModel(name: 'Eurocargo', years: '1991-2026'),
    VehicleModel(name: 'S-Way', years: '2019-2026'),
    VehicleModel(name: 'X-Way', years: '2019-2026'),
    VehicleModel(name: 'eDaily', years: '2023-2026'),
  ]),

  // === AMERİKAN MARKALARI (EK) ===
  VehicleBrand(name: 'RAM', models: [
    VehicleModel(name: '1500', years: '1994-2026'),
    VehicleModel(name: '1500 TRX', years: '2021-2026'),
    VehicleModel(name: '2500', years: '1994-2026'),
    VehicleModel(name: '3500', years: '1994-2026'),
    VehicleModel(name: 'ProMaster', years: '2013-2026'),
    VehicleModel(name: 'ProMaster City', years: '2015-2026'),
  ]),

  VehicleBrand(name: 'Dodge', models: [
    VehicleModel(name: 'Challenger', years: '2008-2026'),
    VehicleModel(name: 'Charger', years: '2006-2026'),
    VehicleModel(name: 'Durango', years: '1998-2026'),
    VehicleModel(name: 'Hornet', years: '2023-2026'),
    VehicleModel(name: 'Journey', years: '2008-2020'),
    VehicleModel(name: 'Viper', years: '1991-2017'),
  ]),

  VehicleBrand(name: 'Cadillac', models: [
    VehicleModel(name: 'CT4', years: '2020-2026'),
    VehicleModel(name: 'CT5', years: '2019-2026'),
    VehicleModel(name: 'Escalade', years: '1999-2026'),
    VehicleModel(name: 'XT4', years: '2018-2026'),
    VehicleModel(name: 'XT5', years: '2016-2026'),
    VehicleModel(name: 'XT6', years: '2019-2026'),
    VehicleModel(name: 'Lyriq', years: '2022-2026'),
  ]),

  VehicleBrand(name: 'GMC', models: [
    VehicleModel(name: 'Sierra', years: '1999-2026'),
    VehicleModel(name: 'Canyon', years: '2004-2026'),
    VehicleModel(name: 'Yukon', years: '1992-2026'),
    VehicleModel(name: 'Acadia', years: '2007-2026'),
    VehicleModel(name: 'Terrain', years: '2009-2026'),
    VehicleModel(name: 'Hummer EV', years: '2022-2026'),
  ]),

  VehicleBrand(name: 'Lincoln', models: [
    VehicleModel(name: 'Aviator', years: '2019-2026'),
    VehicleModel(name: 'Corsair', years: '2019-2026'),
    VehicleModel(name: 'Nautilus', years: '2018-2026'),
    VehicleModel(name: 'Navigator', years: '1998-2026'),
    VehicleModel(name: 'Continental', years: '2016-2020'),
  ]),

  VehicleBrand(name: 'Buick', models: [
    VehicleModel(name: 'Enclave', years: '2007-2026'),
    VehicleModel(name: 'Encore', years: '2012-2026'),
    VehicleModel(name: 'Encore GX', years: '2019-2026'),
    VehicleModel(name: 'Envision', years: '2014-2026'),
  ]),

  VehicleBrand(name: 'Chrysler', models: [
    VehicleModel(name: '300', years: '2004-2026'),
    VehicleModel(name: 'Pacifica', years: '2016-2026'),
    VehicleModel(name: 'Voyager', years: '2020-2026'),
  ]),

  // === DİĞER ===
  VehicleBrand(name: 'Lada', models: [
    VehicleModel(name: 'Vesta', years: '2015-2026'),
    VehicleModel(name: 'Granta', years: '2011-2026'),
    VehicleModel(name: 'Niva', years: '1977-2026'),
    VehicleModel(name: 'Niva Travel', years: '2021-2026'),
    VehicleModel(name: 'XRAY', years: '2015-2022'),
    VehicleModel(name: 'Largus', years: '2012-2026'),
    VehicleModel(name: 'Priora', years: '2007-2018'),
    VehicleModel(name: 'Kalina', years: '2004-2018'),
  ]),

  VehicleBrand(name: 'Lotus', models: [
    VehicleModel(name: 'Emira', years: '2021-2026'),
    VehicleModel(name: 'Eletre', years: '2023-2026'),
    VehicleModel(name: 'Emeya', years: '2024-2026'),
    VehicleModel(name: 'Evija', years: '2024-2026'),
    VehicleModel(name: 'Elise', years: '1996-2021'),
    VehicleModel(name: 'Exige', years: '2000-2021'),
    VehicleModel(name: 'Evora', years: '2009-2021'),
  ]),

  VehicleBrand(name: 'Acura', models: [
    VehicleModel(name: 'TLX', years: '2014-2026'),
    VehicleModel(name: 'Integra', years: '2022-2026'),
    VehicleModel(name: 'MDX', years: '2001-2026'),
    VehicleModel(name: 'RDX', years: '2006-2026'),
    VehicleModel(name: 'NSX', years: '2016-2022'),
    VehicleModel(name: 'ZDX', years: '2024-2026'),
  ]),

  VehicleBrand(name: 'Bugatti', models: [
    VehicleModel(name: 'Chiron', years: '2016-2026'),
    VehicleModel(name: 'Chiron Sport', years: '2018-2026'),
    VehicleModel(name: 'Chiron Super Sport', years: '2021-2026'),
    VehicleModel(name: 'Divo', years: '2019-2021'),
    VehicleModel(name: 'Centodieci', years: '2022-2026'),
    VehicleModel(name: 'Mistral', years: '2024-2026'),
    VehicleModel(name: 'Tourbillon', years: '2026-2026'),
    VehicleModel(name: 'Veyron', years: '2005-2015'),
  ]),

  VehicleBrand(name: 'Pagani', models: [
    VehicleModel(name: 'Huayra', years: '2012-2026'),
    VehicleModel(name: 'Huayra BC', years: '2016-2020'),
    VehicleModel(name: 'Huayra Roadster', years: '2017-2026'),
    VehicleModel(name: 'Utopia', years: '2023-2026'),
    VehicleModel(name: 'Zonda', years: '1999-2019'),
  ]),

  VehicleBrand(name: 'Koenigsegg', models: [
    VehicleModel(name: 'Jesko', years: '2020-2026'),
    VehicleModel(name: 'Gemera', years: '2021-2026'),
    VehicleModel(name: 'Regera', years: '2016-2026'),
    VehicleModel(name: 'CC850', years: '2022-2026'),
    VehicleModel(name: 'Agera RS', years: '2015-2018'),
  ]),

  VehicleBrand(name: 'Lucid', models: [
    VehicleModel(name: 'Air', years: '2021-2026'),
    VehicleModel(name: 'Air Pure', years: '2022-2026'),
    VehicleModel(name: 'Air Touring', years: '2022-2026'),
    VehicleModel(name: 'Air Grand Touring', years: '2022-2026'),
    VehicleModel(name: 'Gravity', years: '2025-2026'),
  ]),

  VehicleBrand(name: 'Rivian', models: [
    VehicleModel(name: 'R1T', years: '2021-2026'),
    VehicleModel(name: 'R1S', years: '2022-2026'),
    VehicleModel(name: 'R2', years: '2026-2026'),
    VehicleModel(name: 'R3', years: '2026-2026'),
  ]),

  VehicleBrand(name: 'Fisker', models: [
    VehicleModel(name: 'Ocean', years: '2023-2026'),
    VehicleModel(name: 'Pear', years: '2025-2026'),
    VehicleModel(name: 'Ronin', years: '2025-2026'),
  ]),

  VehicleBrand(name: 'VinFast', models: [
    VehicleModel(name: 'VF 6', years: '2023-2026'),
    VehicleModel(name: 'VF 7', years: '2023-2026'),
    VehicleModel(name: 'VF 8', years: '2022-2026'),
    VehicleModel(name: 'VF 9', years: '2022-2026'),
    VehicleModel(name: 'VF 3', years: '2024-2026'),
    VehicleModel(name: 'VF 5', years: '2024-2026'),
  ]),

  VehicleBrand(name: 'smart', models: [
    VehicleModel(name: 'fortwo', years: '1998-2026'),
    VehicleModel(name: 'forfour', years: '2004-2026'),
    VehicleModel(name: '#1', years: '2022-2026'),
    VehicleModel(name: '#3', years: '2023-2026'),
  ]),

  VehicleBrand(name: 'Maybach', models: [
    VehicleModel(name: 'S-Class', years: '2015-2026'),
    VehicleModel(name: 'GLS', years: '2020-2026'),
    VehicleModel(name: 'EQS SUV', years: '2023-2026'),
  ]),
];

class FuelType {
  final String id;
  final String name;

  const FuelType({required this.id, required this.name});
}

final List<FuelType> fuelTypes = [
  FuelType(id: 'benzin', name: 'Benzin'),
  FuelType(id: 'dizel', name: 'Dizel'),
  FuelType(id: 'lpg', name: 'LPG'),
  FuelType(id: 'benzin_lpg', name: 'Benzin + LPG'),
  FuelType(id: 'hibrit', name: 'Hibrit'),
  FuelType(id: 'plug_in_hibrit', name: 'Plug-in Hibrit'),
  FuelType(id: 'elektrik', name: 'Elektrik'),
  FuelType(id: 'dizel_hibrit', name: 'Dizel Hibrit'),
];

List<int> getYearList() {
  final currentYear = DateTime.now().year;
  return List.generate(46, (i) => currentYear + 1 - i); // 1980'den günümüze
}

// Yardımcı fonksiyonlar
List<String> getBrandNames() {
  return vehicleBrands.map((b) => b.name).toList();
}

List<String> getModelsByBrand(String brandName) {
  final brand = vehicleBrands.firstWhere(
    (b) => b.name == brandName,
    orElse: () => VehicleBrand(name: '', models: []),
  );
  return brand.models.map((m) => m.name).toList();
}

VehicleModel? getModelInfo(String brandName, String modelName) {
  final brand = vehicleBrands.firstWhere(
    (b) => b.name == brandName,
    orElse: () => VehicleBrand(name: '', models: []),
  );
  try {
    return brand.models.firstWhere((m) => m.name == modelName);
  } catch (e) {
    return null;
  }
}
